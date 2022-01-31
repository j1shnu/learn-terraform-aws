output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "elasticache_conf_endpoint" {
  value = aws_elasticache_replication_group.cluster.configuration_endpoint_address
}

output "zookeeper_connect_string" {
  value = aws_msk_cluster.kafka.zookeeper_connect_string
}