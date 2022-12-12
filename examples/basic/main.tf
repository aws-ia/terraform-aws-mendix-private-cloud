module "mendix_private_cloud_example" {
  source = "../.."

  aws_region                   = var.aws_region
  domain_name                  = var.domain_name
  certificate_expiration_email = var.certificate_expiration_email
  s3_bucket_name               = var.s3_bucket_name
  cluster_id                   = var.cluster_id
  cluster_secret               = var.cluster_secret
  mendix_operator_version      = var.mendix_operator_version
}

provider "aws" {
  region = "eu-central-1"
}