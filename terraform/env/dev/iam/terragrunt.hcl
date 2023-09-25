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

inputs = {

  iam = {
    task_execution_role   = "TripvibeTaskExecutionRole"
    resources             = ["arn:aws:ssm:us-east-1:183066416469:parameter/tripvibe/backend/*"]
    task_execution_policy = "${local.project-name}-task-execution-policy"
    task_role             = "TripvibeTaskRole"
    task_policy           = "${local.project-name}-task-policy"
  }
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules/iam"
}