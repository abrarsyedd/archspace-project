output "bucket_endpoint" {
  description = "The regional domain name for the S3 bucket"
  value       = aws_s3_bucket.archspace_bucket.bucket_regional_domain_name
}

output "website_endpoint" {
  description = "The regional domain name for the S3 bucket"
  value = aws_s3_bucket_website_configuration.archspace_website.website_endpoint
}