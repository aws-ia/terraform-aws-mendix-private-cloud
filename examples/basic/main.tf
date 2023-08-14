module "mendix_private_cloud_example" {
  source = "../.."

  aws_region                   = var.aws_region
  domain_name                  = var.domain_name
  certificate_expiration_email = var.certificate_expiration_email
  s3_bucket_name               = var.s3_bucket_name
  namespace_id                 = var.namespace_id
  namespace_secret             = var.namespace_secret
  mendix_operator_version      = var.mendix_operator_version
}

provider "aws" {}