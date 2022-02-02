variable "cluster_version" {}
variable "ssh_key_name" {}
variable "node_grp_name" {}
variable "instance_type" {}
variable "node_min_size" {}
variable "node_max_size" {}
variable "node_desired_size" {}

data "aws_key_pair" "key" {
  key_name = var.ssh_key_name
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.2.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  eks_managed_node_groups = {
    node_group = {
      name         = var.node_grp_name
      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      instance_types = var.instance_type
      key_name       = data.aws_key_pair.key.key_name

      update_config = {
        max_unavailable = 1
      }
    }
  }
}
