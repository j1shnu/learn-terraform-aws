
# learn-terraform-aws

My learning path of provisioning AWS services using terraform.

### AWS Services 
[x] VPC
[x] EKS with EKS managed node group
[x] RDS (PostgreSQL)
[x] ElastiCache (Redis) 

### Provisioning steps and commands
- Rename `terraform.tfvars.temaple` to `terraform.tfvars` and edit the default values as per need.
- `terraform init` to initialize current dir with given configuration.
- `terraform plan` to view changes required by the current configuration.
- `terraform apply` to apply the changes proposed in plan. (provision the changes)