#Image may be redeployed with the same tag.
#tfsec:ignore:*
resource "aws_ecr_repository" "mendix_ecr" {
  name                 = var.registry_repository_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}