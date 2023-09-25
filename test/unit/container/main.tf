module "container" {
  source = "../../../terraform/modules/container"

  target_group_arn = module.alb.target_group_arn
  # target_group_arn = "${module.alb.target_group_arns[0]}"
  s3_bucket       = module.s3.backend_s3_bucket_name
  security_groups = module.security.backend_security_group_id[*]
  # tags = local.tags
  subnet_ids = module.vpc.vpc_public_subnet_id
  # subnet_ids = module.vpc.vpc_private_subnet_id
  vpc_id = module.vpc.vpc_id
}

module "loadbalancer" {
  source = "../../../terraform/modules/loadbalancer"

  security_groups = module.security.alb_security_group_id[*]
  subnets         = module.vpc.vpc_public_subnet_id
  vpc_id          = module.vpc.vpc_id
}

module "storage" {
  source = "../../../terraform/modules/storage"
}

module "firewall" {
  source = "../../../terraform/modules/firewall"

  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "../../../terraform/modules/vpc"
}

output "alb_dns" {
  description = "DNS name of the load balancer."
  value       = module.alb.alb_dns
}

output "cluster_name" {
  description = "name of the cluster"
  value       = module.ecs.cluster_name
}