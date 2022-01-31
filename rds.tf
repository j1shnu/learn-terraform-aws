variable "rds_name" {}
variable "pg_version" {}
variable "db_instance_class" {}
variable "db_storage" {}
variable "db_max_storage" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "db_port" {}

resource "aws_security_group_rule" "rds-rule" {
  security_group_id        = module.vpc.default_security_group_id
  protocol                 = "-1"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = module.eks.cluster_primary_security_group_id

}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = var.rds_name

  engine         = "postgres"
  engine_version = var.pg_version

  instance_class        = var.db_instance_class
  allocated_storage     = var.db_storage
  max_allocated_storage = var.db_max_storage
  storage_type          = "gp2"

  name     = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids             = module.vpc.public_subnets
  publicly_accessible    = true

  family               = format("postgres%s", split(".", var.pg_version)[0])
  major_engine_version = split(".", var.pg_version)[0]
}
