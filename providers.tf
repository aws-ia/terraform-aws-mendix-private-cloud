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
      version = ">= 5.10"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
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
      version = ">= 2.2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}