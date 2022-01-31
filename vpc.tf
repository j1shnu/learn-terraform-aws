variable "vpc_name" {}
variable "vpc_cidr_block" {}
variable "public_subnet_cidr_blocks" {}
variable "cluster_name" {}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.3"

  name                 = var.vpc_name
  cidr                 = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  public_subnets = var.public_subnet_cidr_blocks
  azs            = data.aws_availability_zones.available.names

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }
}
