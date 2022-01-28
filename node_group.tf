
variable "ssh_key_name" {}
variable "node_grp_name" {}
variable "instance_type" {}
variable "node_min_size" {}
variable "node_max_size" {}
variable "node_desired_size" {}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_key_pair" "key" {
  key_name = var.ssh_key_name
}

module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name            = var.node_grp_name
  cluster_name    = data.aws_eks_cluster.eks.id
  cluster_version = data.aws_eks_cluster.eks.version

  vpc_id     = data.aws_eks_cluster.eks.vpc_config[0].vpc_id
  subnet_ids = data.aws_eks_cluster.eks.vpc_config[0].subnet_ids


  min_size     = var.node_min_size
  max_size     = var.node_max_size
  desired_size = var.node_desired_size

  instance_types = var.instance_type
  key_name       = data.aws_key_pair.key.key_name
}

