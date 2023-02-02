variable "aws_region" {
  type        = string
  description = "AWS Region name"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
}

variable "oidc_provider" {
  type        = string
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
}

variable "domain_name" {
  type        = string
  description = "Domain name"
}