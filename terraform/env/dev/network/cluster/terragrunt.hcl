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
  ecs-cluster = {
    name = "${local.project-name}-${local.env}-cluster"
    setting = {
      name  = "containerInsights"
      value = "disabled"
    }
  }
  tags = local.tags
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules/cluster"
}
