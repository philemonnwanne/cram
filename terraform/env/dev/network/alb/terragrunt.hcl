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
  domain-name = include.root.locals.domain-name
  env = include.env.locals.environment
  tags = include.env.locals.tags
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("env")}/network/vpc"
  mock_outputs = {
    vpc_id = "mock-vpc-id"
    vpc_public_subnet_id = ["mock-subnet-list"]
  }
}

dependency "firewall" {
  config_path = "${get_parent_terragrunt_dir("env")}/network/firewall"
  mock_outputs = {
    alb_security_group_id = ["mock-sec-grp-list"]
  }
}

inputs = {

  target_group = {
    name = "${local.project-name}-${local.env}-backend-tg"
    port        = 4000
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = dependency.vpc.outputs.vpc_id
  }

  alb = {
    name = "${local.project-name}-${local.env}-backend-alb"
    subnets         = dependency.vpc.outputs.vpc_public_subnet_id
    security_groups = dependency.firewall.outputs.alb_security_group_id[*]
  }

  alb_http_listener = {
    port        = 4000
    protocol    = "HTTP"
  }

  alb_https_listener = {
    port        = 443
    protocol    = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
  }

  domain_name =  local.domain-name

  tags = local.tags
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules/network/loadbalancer"
}
