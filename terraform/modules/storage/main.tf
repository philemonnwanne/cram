# module/buckets/main.tf

# ===============-========================
# BACKEND BUCKET
# create an S3 bucket for our backend uploads
resource "aws_s3_bucket" "backend" {
  bucket        = var.backend_bucket.bucket_name
  force_destroy = var.backend_bucket.force_destroy

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "backend" {
  bucket                  = aws_s3_bucket.backend.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "backend" {
  bucket = aws_s3_bucket.backend.id
  rule {
    object_ownership = var.backend_bucket.object_ownership
  }
}
# BACKEND BUCKET
# ===============-========================

# ===============-========================
# CLOUDFRONT BUCKET

# create an S3 bucket for our static web site artifacts
resource "aws_s3_bucket" "cloudfront" {
  bucket = var.cloudfront_bucket.bucket_name
  tags   = var.tags
}

# upload the content of the `build` folder as S3 objects
resource "aws_s3_object" "bucket_upload" {
  for_each     = fileset("../../../frontend/dist", "**/*.*")
  bucket       = aws_s3_bucket.cloudfront.id
  key          = each.key
  source       = "../../../frontend/dist/${each.value}"
  etag         = filemd5("../../../frontend/dist/${each.value}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}

# CLOUDFRONT BUCKET
# ===============-========================

locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
}