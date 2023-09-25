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

dependency "cloudfront" {
  config_path = "${get_parent_terragrunt_dir("env")}/app/cloudfront"
  mock_outputs = {
    cloudfront_domain_name    = "mock-cloudfront-alias"
    cloudfront_hosted_zone_id = "mock-cloudfront-zone"
  }
}

dependency "loadbalancer" {
  config_path = "${get_parent_terragrunt_dir("env")}/network/loadbalancer"
  mock_outputs = {
    alb_dns     = "mock-alb-alias"
    alb_zone_id = "mock-alb-zone"
  }
}

inputs = {

  zone_id = "Z05533031DW7NWR1EH80D"

  record_one = {
    allow_overwrite          = true
    name                     = "frontend"
    cloudfront_alias_name    = dependency.cloudfront.outputs.cloudfront_domain_name
    cloudfront_alias_zone_id = dependency.cloudfront.outputs.cloudfront_hosted_zone_id
  }

  record_two = {
    allow_overwrite   = true
    name              = "backend"
    alb_alias_name    = dependency.loadbalancer.outputs.alb_dns
    alb_alias_zone_id = dependency.loadbalancer.outputs.alb_zone_id
  }
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules/dns"
}