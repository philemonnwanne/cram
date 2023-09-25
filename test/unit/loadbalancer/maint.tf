module "loadbalancer" {
  source = "../../../terraform/modules/loadbalancer"

  security_groups = module.security.alb_security_group_id[*]
  subnets         = module.vpc.vpc_public_subnet_id
  vpc_id          = module.vpc.vpc_id
  # backend_target = module.ecs.backend_task_id
}

output "alb_arn" {
  description = "The ARN name of the load balancer."
  value       = module.alb.alb_arn
}

module "firewall" {
  source = "../../../terraform/modules/firewall"

  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "../../../terraform/modules/vpc"
}