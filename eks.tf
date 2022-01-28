variable "cluster_version" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.2.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.eks-vpc.public_subnets
  vpc_id          = module.eks-vpc.vpc_id


}
