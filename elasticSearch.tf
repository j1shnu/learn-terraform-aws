variable "es_domain_name" {}
variable "es_version" {}
variable "es_instance_type" {}
variable "es_instance_count" {}
variable "es_volume_type" {}
variable "es_volume_size" {}
variable "es_cron_expression_for_recurrence" {}
variable "es_maintenance_schedule_duration" {}

resource "aws_iam_service_linked_role" "es_role" {
  aws_service_name = "es.amazonaws.com"
  description      = "Allows Amazon ES to manage AWS resources for a domain on your behalf."
}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.es_domain_name
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type  = var.es_instance_type
    instance_count = var.es_instance_count
  }

  ebs_options {
    ebs_enabled = true
    volume_type = var.es_volume_type
    volume_size = var.es_volume_size
  }

  auto_tune_options {
    desired_state = "ENABLED"
    maintenance_schedule {
      start_at = timeadd(timestamp(), "1h")
      duration {
        value = var.es_maintenance_schedule_duration
        unit  = "HOURS"
      }
      cron_expression_for_recurrence = var.es_cron_expression_for_recurrence
    }
    rollback_on_disable = "NO_ROLLBACK"
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  vpc_options {
    security_group_ids = [module.vpc.default_security_group_id]
    subnet_ids         = [module.vpc.public_subnets[0]]
  }

  depends_on = [aws_iam_service_linked_role.es_role]
}

resource "aws_elasticsearch_domain_policy" "policy" {
  domain_name     = aws_elasticsearch_domain.es.domain_name
  access_policies = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": {
              "AWS": "*"
            },
            "Effect": "Allow",
            "Resource": "${aws_elasticsearch_domain.es.arn}/*"
        }
    ]
}
POLICY
}