variable "aws_region" {
  type        = string
  description = "AWS Region name"
}

variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "s3_bucket_name" {
  type        = string
  description = "S3 bucket name"
}

variable "namespace_id" {
  type        = string
  description = "Mendix Private Cloud Namespace ID"
}

variable "namespace_secret" {
  type        = string
  description = "Mendix Private Cloud Namespace Secret"
}

variable "mendix_operator_version" {
  type        = string
  description = "Mendix Private Cloud Operator version"
  default     = "2.16.0"
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

variable "environments_internal_names" {
  type        = list(string)
  default     = ["app1", "app2", "app3"]
  description = "List of internal environments names"

  validation {
    condition     = alltrue([for app in var.environments_internal_names : can(regex("^[a-z0-9]{1,8}$", app))])
    error_message = "Use only lowercase letters and numbers, with a maximum of 8 characters and a minimum of 1 character."
  }
}