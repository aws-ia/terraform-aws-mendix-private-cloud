variable "s3_bucket_name" {
  type        = string
  description = "S3 bucket name"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes Cluster Name"
}

variable "environments_internal_names" {
  type        = list(string)
  description = "List of internal environments names"
}