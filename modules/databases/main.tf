locals {
  database_engine   = "postgres"
  database_username = "postgres"
  database_port     = 5432
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.identifier}_subnet_group"
  subnet_ids = var.subnets
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

#IAM Authentication and performance insights are not needed.
#tfsec:ignore:*
resource "aws_db_instance" "default" {
  allocated_storage                   = 10
  identifier                          = var.identifier
  db_name                             = "postgres"
  engine                              = local.database_engine
  engine_version                      = var.postgres_version
  instance_class                      = var.rds_instance_class
  port                                = local.database_port
  username                            = local.database_username
  password                            = random_password.password.result
  storage_encrypted                   = true
  backup_retention_period             = 7
  skip_final_snapshot                 = true
  db_subnet_group_name                = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids              = [var.cluster_primary_security_group_id]
  iam_database_authentication_enabled = true
}
