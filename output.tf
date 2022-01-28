output "default-vpc-sg" {
  description = "default vpc security_group_id"
  value       = module.eks-vpc.default_security_group_id
}

output "vpc-subnets" {
  description = "public subnets in vpc"
  value       = module.eks-vpc.public_subnets
}
