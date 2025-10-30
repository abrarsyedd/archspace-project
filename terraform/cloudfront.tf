# Define a local variable for the origin ID
locals {
  s3_origin_id = "S3-Origin-${var.bucket_name}"
}

# 1. Create the CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "OAC-${aws_s3_bucket.archspace_bucket.id}"
  description                       = "Origin Access Control for ${aws_s3_bucket.archspace_bucket.id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# 2. Create the CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.archspace_bucket.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  # Default cache behavior for all files
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    # Use a managed policy for caching optimized for S3
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none" # No geo-restrictions
    }
  }

  # Use the default CloudFront SSL certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Custom error response for 404s (e.g., bad URL)
  # This routes users back to index.html, which is good for multi-page sites
  custom_error_response {
    error_code         = 404
    response_page_path = "/index.html"
    response_code      = 200
  }

  # Custom error response for 403s (Forbidden)
  custom_error_response {
    error_code         = 403
    response_page_path = "/index.html"
    response_code      = 200
  }
}