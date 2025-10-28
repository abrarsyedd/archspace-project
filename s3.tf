terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # You can change this to your preferred region
}

# --- Mime Type Map ---

# This local block defines the mime types to fix the error
locals {
  mime_types = {
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".html" = "text/html"
    ".svg"  = "image/svg+xml"
    ".txt"  = "text/plain"
  }
}

# --- S3 Bucket ---

# 1. Create the S3 bucket
resource "aws_s3_bucket" "archspace_bucket" {
  bucket = var.bucket_name
}

# 2. Configure the Public Access Block
resource "aws_s3_bucket_public_access_block" "assets_pab" {
  bucket = aws_s3_bucket.archspace_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 3. Apply the Bucket Policy you provided
resource "aws_s3_bucket_policy" "assets_policy" {
  bucket = aws_s3_bucket.archspace_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.archspace_bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.assets_pab]
}

# 4. Apply the CORS Policy you provided
resource "aws_s3_bucket_cors_configuration" "assets_cors" {
  bucket = aws_s3_bucket.archspace_bucket.id

  cors_rule {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "HEAD"]
      allowed_origins = ["*"]
      expose_headers  = []
  }
      
}

# 5. Find all files in your local assets folder
locals {
  asset_files = fileset(var.folder, "**/*.*") # Finds all files recursively
}

# 6. Upload each file to S3
resource "aws_s3_object" "asset_files" {
  for_each = local.asset_files # Loop over all files found

  bucket = aws_s3_bucket.archspace_bucket.id
  key    = each.value                         
  source = "${var.folder}/${each.value}" 
  etag   = filemd5("${var.folder}/${each.value}") 

  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
}

resource "aws_s3_bucket_website_configuration" "archspace_website" {
  bucket = aws_s3_bucket.archspace_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

