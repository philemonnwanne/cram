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

inputs = {
  vpc = {
    name = "${local.project-name}-${local.env}-vpc"
    cidr = "10.0.0.0/16"
    azs = ["us-east-1a", "us-east-1b"]
    private_subnets = ["10.0.128.0/20", "10.0.144.0/20"]
    private_subnet_names = ["${local.project-name}-subnet-private1-us-east-1a", "${local.project-name}-subnet-private2-us-east-1b"]
    public_subnets = ["10.0.0.0/20", "10.0.16.0/20"]
    public_subnet_names = ["${local.project-name}-subnet-public1-us-east-1a", "${local.project-name}-subnet-public2-us-east-1b"]
  }
  tags = local.tags
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules/network/vpc"
}
