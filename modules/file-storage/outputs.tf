output "filestorage_endpoint" {
  description = "S3 endpoint"
  value       = aws_s3_bucket.apps_shared_bucket.bucket_domain_name
}

output "filestorage_regional_endpoint" {
  description = "S3 regional endpoint"
  value       = aws_s3_bucket.apps_shared_bucket.bucket_regional_domain_name
}

output "filestorage_access_key" {
  description = "S3 access key"
  value       = aws_iam_access_key.s3.id
}

output "filestorage_secret_key" {
  description = "S3 secret key"
  value       = aws_iam_access_key.s3.secret
  sensitive   = true
}
