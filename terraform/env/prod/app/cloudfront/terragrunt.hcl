include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

locals {
  project-name = include.root.locals.project-name
  env          = include.env.locals.environment
  tags         = include.env.locals.tags
}

dependency "iam" {
  config_path = "${get_parent_terragrunt_dir("env")}/iam"
  mock_outputs = {
    origin_access_identity = "mock-origin-access-identity"
  }
}

dependency "storage" {
  config_path = "${get_parent_terragrunt_dir("env")}/storage"
  mock_outputs = {
    s3_domain_name = "mock-s3-domain-name"
  }
}

inputs = {

  cloudfront = {
    enabled             = true
    comment             = "production distribution for ${local.project-name}"
    default_root_object = "index.html"
    aliases             = ["frontend.philemonnwanne.me"]

    alb_origin_id   = "${local.project-name}-alb-origin"
    alb_domain_name = "backend.philemonnwanne.me"

    origin_protocol_policy = "match-viewer"
    origin_ssl_protocols   = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]

    s3_origin_id           = "${local.project-name}-s3-origin"
    s3_domain_name         = "dependency.storage.outputs.cloudfront_s3_domain_name"
    origin_access_identity = dependency.iam.outputs.origin_access_identity

    domain_name = "philemonnwanne.me"
  }

  default_cache_behavior = {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    min_ttl         = 0
    default_ttl     = 3600
    max_ttl         = 86400

    target_origin_id       = "${local.project-name}-s3-origin"
    viewer_protocol_policy = "allow-all"
    compress               = true
  }

  ordered_cache_behavior = {
    path_pattern           = "/api/*"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "${local.project-name}-alb-origin"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  tags = local.tags
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules/cloudfront"
}