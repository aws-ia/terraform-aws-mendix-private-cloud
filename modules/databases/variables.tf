variable "identifier" {
  description = "VPC identifierD"
  type        = string
}

variable "subnets" {
  description = "VPC subnets"
  type        = list(string)
}

variable "cluster_primary_security_group_id" {
  description = "VPC primary security group ID"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS Instance class"
  default     = "db.t3.small"
  type        = string
}

variable "file_storage_endpoint" {
  description = "S3 regional endpoint"
  type        = string
}

variable "secrets_manager_name" {
  type        = string
  description = "Secrets Manager name"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes Cluster Name"
}

variable "aws_caller_identity_account_id" {
  type        = string
  description = "AWS Caller Identity Account ID"
}

variable "oidc_provider" {
  type        = string
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
}

variable "environment_internal_name" {
  type        = string
  description = "Environment internal name"
}

variable "filestorage_shared_bucket_arn" {
  type        = string
  description = "S3 shared bucket ARN"
}