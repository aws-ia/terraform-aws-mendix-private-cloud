output "filestorage_endpoint" {
  description = "S3 endpoint"
  value       = aws_s3_bucket.apps_shared_bucket.bucket_domain_name
}

output "filestorage_regional_endpoint" {
  description = "S3 Regional endpoint"
  value       = aws_s3_bucket.apps_shared_bucket.bucket_regional_domain_name
}

output "filestorage_shared_bucket_arn" {
  description = "S3 shared bucket ARN"
  value       = aws_s3_bucket.apps_shared_bucket.arn
}
