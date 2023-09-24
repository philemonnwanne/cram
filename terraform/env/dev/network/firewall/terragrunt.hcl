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
  env = include.env.locals.environment
  tags = include.env.locals.tags
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("env")}/network/vpc"
  mock_outputs = {
    vpc_id = "mock-vpc-id"
  }
  // skip_outputs = false 
}

inputs = {

  backend_sg = {
    name = "${local.project-name}-${local.env}-backend-sg"
    vpc_id      = dependency.vpc.outputs.vpc_id
    from_port = 4000
    to_port = 4000
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
    egress_cidr_blocks = ["0.0.0.0/0"]
    egress_rules = ["all-all"]
  }

  alb_sg = {
    name = "${local.project-name}-${local.env}-alb-sg"
    vpc_id      = dependency.vpc.outputs.vpc_id
    alb_ingress_with_cidr_blocks = [
      {
        from_port   = 4000
        to_port     = 4000
        protocol    = "tcp"
        description = "allow access to the backend-target-group"
        cidr_blocks = "0.0.0.0/0"
      }
    ]
    ingress_cidr_blocks = ["0.0.0.0/0"]
    alb_ingress_rules = [
      "http-80-tcp",
      "https-443-tcp"
    ]
    egress_cidr_blocks = ["0.0.0.0/0"]
    egress_rules = ["all-all"]
    }

  tags = local.tags
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules/network/firewall"
}