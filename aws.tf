variable "access_key" {}
variable "secret_key" {}

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "ap-northeast-1"
}

resource "aws_security_group" "allow_local" {
    name = "allow_local"
    description = "Allow Only Local traffic"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["153.156.43.75/32","172.31.0.0/16"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_elb" "elb-ver1" {
  name = "ELB-V1"
  availability_zones = ["ap-northeast-1a"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  security_groups = [
      "${aws_security_group.allow_local.id}"
  ]
}

resource "aws_elb" "elb-ver2" {
  name = "ELB-V2"
  availability_zones = ["ap-northeast-1a"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  security_groups = [
      "${aws_security_group.allow_local.id}"
  ]
}

resource "aws_launch_configuration" "as_ver1" {
    name = "ver1"
    image_id = "ami-3c82685d"
    key_name = "devenv-key"
    instance_type = "m3.medium"
    security_groups = [
        "${aws_security_group.allow_local.id}"
    ]
}

resource "aws_launch_configuration" "as_ver2" {
    name = "ver2"
    image_id = "ami-bf8d67de"
    key_name = "devenv-key"
    instance_type = "m3.medium"
    security_groups = [
        "${aws_security_group.allow_local.id}"
    ]
}

resource "aws_autoscaling_group" "auto-ver1" {
  availability_zones = ["ap-northeast-1a"]
  name = "autoscale-ver1"
  max_size = 1
  min_size = 1
  desired_capacity = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.as_ver1.name}"
  load_balancers = ["${aws_elb.elb-ver1.name}"]
}

resource "aws_autoscaling_group" "auto-ver2" {
  availability_zones = ["ap-northeast-1a"]
  name = "autoscale-ver2"
  max_size = 1
  min_size = 1
  desired_capacity = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.as_ver2.name}"
  load_balancers = ["${aws_elb.elb-ver2.name}"]
}
