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

dependency "storage" {
  config_path = "${get_parent_terragrunt_dir("env")}/storage"
  mock_outputs = {
    cloudfront_s3_id    = "mock-bucket-id"
    cloudfront_s3_arn = "mock-bucket-resources"
  }
}

inputs = {

  ecs_policy = {
    task_execution_role   = "TripvibeTaskExecutionRole"
    resources             = ["arn:aws:ssm:us-east-1:183066416469:parameter/tripvibe/backend/*"]
    task_execution_policy = "${local.project-name}-task-execution-policy"
    task_role             = "TripvibeTaskRole"
    task_policy           = "${local.project-name}-task-policy"
  }

  cloudfront_bucket_policy = {
    bucket    = dependency.storage.outputs.cloudfront_s3_id
    actions   = ["s3:GetObject"]
    resources = ["${dependency.storage.outputs.cloudfront_s3_arn}/*"]
    comment   = "cloudfront-${local.project-name}-origin-acess-identity"
  }
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules/iam"
}