module "storage" {
  source = "../../../terraform/modules/storage"

  policy = module.cloudfront.tripvibe_s3_policy
}