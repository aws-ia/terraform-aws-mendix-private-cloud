terraform {
  backend "s3" {
    region         = ""
    bucket         = ""
    key            = "terraform.tfstate"
    dynamodb_table = ""
    encrypt        = true
  }

  required_version = ">= 0.14"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.46"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.29.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks_blueprints.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}