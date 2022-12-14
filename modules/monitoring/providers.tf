terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.35"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}