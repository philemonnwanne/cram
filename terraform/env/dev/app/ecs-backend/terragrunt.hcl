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

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("env")}/network/vpc"
  mock_outputs = {
    vpc_id               = "mock-vpc-id"
    vpc_public_subnet_id = ["mock-subnet-list"]
  }
}

dependency "firewall" {
  config_path = "${get_parent_terragrunt_dir("env")}/network/firewall"
  mock_outputs = {
    alb_security_group_id = ["mock-sec-grp-list"]
  }
}

dependency "loadbalancer" {
  config_path = "${get_parent_terragrunt_dir("env")}/network/loadbalancer"
  mock_outputs = {
    target_group_arn = "arn:aws:ssm:us-east-1:183066416469:parameter/tripvibe/backend"
  }
}

dependency "cluster" {
  config_path = "${get_parent_terragrunt_dir("env")}/network/cluster"
  mock_outputs = {
    cluster_id = "mock-cluster-id"
  }
}

dependency "iam" {
  config_path = "${get_parent_terragrunt_dir("env")}/iam"
  mock_outputs = {
    execution_role_arn = "arn:aws:ssm:us-east-1:183066416469:parameter/tripvibe/execution_role_arn"
    task_role_arn = "arn:aws:ssm:us-east-1:183066416469:parameter/tripvibe/task_role_arn"
  }
}

inputs = {

  task_definition = {
    family               = "backend"
    execution_role_arn   = dependency.iam.outputs.execution_role_arn
    task_role_arn        = dependency.iam.outputs.task_role_arn
    task_name            = "backend"
    ecr_image_uri        = "183066416469.dkr"
    aws_region           = "us-east-1"
    container_port       = 4000
    protocol             = "tcp"
    app_protocol         = "http"
    log_driver           = "awslogs"
    secret_manager_arn   = "arn:aws:ssm:us-east-1:183066416469:parameter/tripvibe/backend"
    bucket               = "tripy-one"
    cpu                  = 256
    memory               = 512
    cloudwatch_log_group = "/ecs/backend"
  }
  tags = local.tags

  service = {
    name             = "backend"
    cluster_id       = dependency.cluster.outputs.cluster_id
    subnets          = dependency.vpc.outputs.vpc_public_subnet_id
    security_groups  = dependency.firewall.outputs.alb_security_group_id[*]
    target_group_arn = dependency.loadbalancer.outputs.target_group_arn
    container_name   = "backend"
    container_port   = 4000
  }
  tags = local.tags
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules/container"
}
