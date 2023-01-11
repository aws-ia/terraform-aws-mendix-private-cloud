locals {
  database_engine   = "postgres"
  database_username = "mendix"
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
  allocated_storage       = 10
  identifier              = var.identifier
  db_name                 = "postgres"
  engine                  = local.database_engine
  instance_class          = var.rds_instance_class
  port                    = local.database_port
  username                = local.database_username
  password                = random_password.password.result
  storage_encrypted       = true
  backup_retention_period = 7
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.cluster_primary_security_group_id]
}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "apps_secrets" {
  name                    = var.secrets_manager_name
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "apps_secrets_version" {
  secret_id = aws_secretsmanager_secret.apps_secrets.id
  secret_string = jsonencode({
    storage-service-name = "com.mendix.storage.s3",
    storage-endpoint     = var.file_storage_endpoint
    storage-bucket-name  = var.environment_internal_name,
    database-type        = "PostgreSQL",
    database-jdbc-url    = "jdbc:postgresql://${aws_db_instance.default.address}:5432/${aws_db_instance.default.db_name}?sslmode=prefer"
    database-name        = "postgres",
    database-username    = "mendix",
    database-password    = aws_db_instance.default.password,
    database-host        = "${aws_db_instance.default.address}:5432"
  })
}

resource "aws_iam_role" "app_irsa_role" {
  name = "${var.cluster_name}-app-role-${var.environment_internal_name}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${var.aws_caller_identity_account_id}:oidc-provider/${var.oidc_provider}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${var.oidc_provider}:aud" : "sts.amazonaws.com",
            "${var.oidc_provider}:sub" : "system:serviceaccount:mendix:${var.environment_internal_name}"
          }
        }
      }
    ]
  })
}

#https://docs.mendix.com/developerportal/deploy/private-cloud-cluster/
#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "app_irsa_policy" {
  name = "${var.cluster_name}-app-policy"
  role = aws_iam_role.app_irsa_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],

        "Resource" : aws_secretsmanager_secret.apps_secrets.arn
      },
      {
        "Action" : [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:PutObject"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "${var.filestorage_shared_bucket_arn}/${var.environment_internal_name}/*"
        ]
      }
    ]
  })
}

