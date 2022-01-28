variable "engine_version" {}
variable "elasticache_node" {}
variable "parameter_group_name" {}
variable "replicas_per_node_group" {}
variable "elasticache_cluster_name" {}
variable "elasticache_cluster_description" {}


resource "aws_elasticache_subnet_group" "elasticache_sub_grp" {
  name       = format("%s-subnet-group", var.elasticache_cluster_name)
  subnet_ids = module.eks-vpc.public_subnets
}

resource "aws_elasticache_replication_group" "cluster" {
  replication_group_id          = var.elasticache_cluster_name
  replication_group_description = var.elasticache_cluster_description
  node_type                     = var.elasticache_node
  engine_version                = var.engine_version
  automatic_failover_enabled    = true
  subnet_group_name             = resource.aws_elasticache_subnet_group.elasticache_sub_grp.name
  security_group_ids            = [module.eks-vpc.default_security_group_id]
  parameter_group_name          = var.parameter_group_name
  cluster_mode {
    replicas_per_node_group = var.replicas_per_node_group
  }
}