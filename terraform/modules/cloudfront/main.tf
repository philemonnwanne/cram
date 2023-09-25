resource "aws_cloudfront_distribution" "tripvibe_distribution" {
  enabled             = var.cloudfront.enabled
  comment             = var.cloudfront.comment
  default_root_object = var.cloudfront.default_root_object
  aliases             = var.cloudfront.aliases

  origin {
    # points CloudFront to the corresponding alb
    origin_id   = var.cloudfront.alb_origin_id
    domain_name = var.cloudfront.alb_domain_name
    custom_origin_config {
      http_port              = 80
      origin_protocol_policy = var.cloudfront.origin_protocol_policy
      origin_ssl_protocols   = var.cloudfront.origin_ssl_protocols
      https_port             = 443
    }
  }

  origin {
    # points CloudFront to the corresponding S3 bucket
    origin_id   = var.cloudfront.s3_origin_id
    domain_name = var.cloudfront.s3_domain_name

    s3_origin_config {
      origin_access_identity = var.cloudfront.origin_access_identity
    }
  }

  default_cache_behavior {
    allowed_methods        = var.default_cache_behavior.allowed_methods
    cached_methods         = var.default_cache_behavior.cached_methods
    min_ttl                = var.default_cache_behavior.min_ttl
    default_ttl            = var.default_cache_behavior.default_ttl
    max_ttl                = var.default_cache_behavior.max_ttl
    target_origin_id       = var.default_cache_behavior.target_origin_id
    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    compress               = var.default_cache_behavior.compress

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern     = var.ordered_cache_behavior.path_pattern
    allowed_methods  = var.ordered_cache_behavior.allowed_methods
    cached_methods   = var.ordered_cache_behavior.cached_methods
    target_origin_id = var.ordered_cache_behavior.target_origin_id
    forwarded_values {
      query_string = true
      headers      = ["Origin"]
      cookies {
        forward = "all"
      }
    }
    min_ttl                = var.ordered_cache_behavior.min_ttl
    default_ttl            = var.ordered_cache_behavior.default_ttl
    max_ttl                = var.ordered_cache_behavior.max_ttl
    compress               = var.ordered_cache_behavior.compress
    viewer_protocol_policy = var.ordered_cache_behavior.viewer_protocol_policy
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = data.aws_acm_certificate.issued.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1"
  }
  tags = var.tags
}

# Find a certificate that is issued
data "aws_acm_certificate" "issued" {
  domain   = var.cloudfront.domain_name
  statuses = ["ISSUED"]
}
