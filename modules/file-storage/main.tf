resource "aws_kms_key" "cmk_shared_bucket" {
  description             = "KMS key ${var.s3_bucket_name}"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.secret_manager_key.json
  enable_key_rotation     = true
}

data "aws_iam_policy_document" "secret_manager_key" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
  }

  statement {
    sid    = "Allow use of the key by apps roles"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        for app_name in var.environments_internal_names :
        "arn:aws:iam::${var.account_id}:role/${var.cluster_name}-app-role-${app_name}"
      ]
    }
  }
}

#S3 versioning and logging disabled for cost reduction
#tfsec:ignore:*
resource "aws_s3_bucket" "apps_shared_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "apps_shared_bucket" {
  bucket = aws_s3_bucket.apps_shared_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.cmk_shared_bucket.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "apps_shared_bucket" {
  bucket = aws_s3_bucket.apps_shared_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "apps_shared_bucket_acl" {
  bucket = aws_s3_bucket.apps_shared_bucket.id
  acl    = "private"
}