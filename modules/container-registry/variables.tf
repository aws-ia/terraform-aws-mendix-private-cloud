variable "registry_repository_name" {
  type        = string
  description = "ECR repository name"
}

variable "region" {
  type        = string
  description = "AWS Region name"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "oidc_provider" {
  type        = string
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
}
