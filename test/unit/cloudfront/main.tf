module "cloudfront" {
  source = "../../../modules/cloudfront"

  resources      = ["${module.s3.cloudfront_s3_arn}/*"]
  s3_domain_name = module.s3.cloudfront_s3_domain_name
}

output "cloudfront_id" {
  value = module.cloudfront.cloudfront_id
}

module "bucket" {
  source = "../../../modules/bucket"

  policy = module.cloudfront.tripvibe_s3_policy
}