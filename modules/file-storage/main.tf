#S3 versioning and logging disabled for cost reduction
#tfsec:ignore:*
resource "aws_s3_bucket" "apps_shared_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "apps_shared_bucket" {
  bucket = aws_s3_bucket.apps_shared_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "apps_shared_bucket" {
  bucket = aws_s3_bucket.apps_shared_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
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

  depends_on = [aws_s3_bucket_ownership_controls.apps_shared_bucket]
}