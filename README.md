# demo

## provisioning(elb, auto scaling)

+ plan
```sh
terraform plan -var-file=secret.tfvars
```

+ do provision
```sh
terraform apply -var-file=secret.tfvars
```

## attach ELB-Version1 -> autoscaling-Version2
```
aws autoscaling attach-load-balancers --auto-scaling-group-name 'autoscale-ver2' --load-balancer-names 'ELB-V1'
aws autoscaling detach-load-balancers --auto-scaling-group-name 'autoscale-ver1' --load-balancer-names 'ELB-V1'
```

## detach ELB-Version2 -> autoscaling-Version2
```
aws autoscaling detach-load-balancers --auto-scaling-group-name 'autoscale-ver2' --load-balancer-names 'ELB-V2'
```

## destory all
+ plan
```sh
terraform plan -destroy -out=./terraform.tfstate -var-file=secret.tfvars
```

+ do provision
```sh
terraform apply ./terraform.tfstate
```
