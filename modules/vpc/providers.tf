terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.46"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}