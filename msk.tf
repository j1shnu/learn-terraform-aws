variable "kms_desc" {}
variable "kms_alias" {}
variable "msk_log_grp_name" {}
variable "msk_cluster_name" {}
variable "kafka_version" {}
variable "num_of_broker_nodes" {}
variable "msk_instance_type" {}
variable "msk_ebs_volume_size" {}


resource "aws_kms_key" "kms" {
  description = var.kms_desc
}

resource "aws_kms_alias" "kms-aliasing" {
  name          = var.kms_alias
  target_key_id = aws_kms_key.kms.key_id
}

resource "aws_cloudwatch_log_group" "msk_log_grp" {
  name = var.msk_log_grp_name
}

resource "aws_msk_cluster" "kafka" {
  cluster_name           = var.msk_cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.num_of_broker_nodes

  broker_node_group_info {
    instance_type   = var.msk_instance_type
    ebs_volume_size = var.msk_ebs_volume_size
    client_subnets  = module.vpc.public_subnets
    security_groups = [module.vpc.default_security_group_id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk_log_grp.name
      }
    }
  }
}