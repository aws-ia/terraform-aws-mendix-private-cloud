variable "aws_region" {
  type        = string
  description = "AWS region name"

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.aws_region))
    error_message = "Must be valid AWS Region name"
  }
}

variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "s3_bucket_name" {
  type        = string
  description = "S3 bucket name"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{3,64}[a-z0-9]$", var.s3_bucket_name))
    error_message = "Incorrect S3 bucket naming rules https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html"
  }
}

variable "cluster_id" {
  type        = string
  description = "Mendix Private Cloud Cluster ID"
}

variable "cluster_secret" {
  type        = string
  description = "Mendix Private Cloud Cluster Secret"
}

variable "mendix_operator_version" {
  type        = string
  description = "Mendix Private Cloud Operator Version"
  default     = "2.9.0"
}

variable "certificate_expiration_email" {
  type        = string
  description = "Let's Encrypt certificate expiration email"
}

variable "allowed_ips" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of IP adresses allowed to access EKS cluster endpoint"
}