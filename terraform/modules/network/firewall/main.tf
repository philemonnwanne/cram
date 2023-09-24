# modules/firewall/main.tf
module "backend_security_group" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.17.1"
  name        = var.backend_sg.name
  description = "security group controlling traffic to backend container downstream the application load balancer"
  vpc_id      = var.backend_sg.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = var.backend_sg.from_port
      to_port                  = var.backend_sg.to_port
      protocol                 = var.backend_sg.protocol
      cidr_blocks              = var.backend_sg.cidr_blocks
      source_security_group_id = module.alb_security_group.security_group_id
    }
  ]
  egress_cidr_blocks      = var.backend_sg.egress_cidr_blocks
  egress_rules            = var.backend_sg.egress_rules
  egress_ipv6_cidr_blocks = []
  tags                    = var.tags
}

module "alb_security_group" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "4.17.1"
  name                     = var.alb_sg.name
  description              = "security group controlling traffic to application load balancer upstream the backend container"
  vpc_id                   = var.alb_sg.vpc_id
  ingress_with_cidr_blocks = var.alb_sg.alb_ingress_with_cidr_blocks
  ingress_cidr_blocks      = var.alb_sg.ingress_cidr_blocks
  ingress_rules            = var.alb_sg.alb_ingress_rules
  egress_cidr_blocks       = var.alb_sg.egress_cidr_blocks
  egress_rules             = var.alb_sg.egress_rules
  egress_ipv6_cidr_blocks  = []
  tags                     = var.tags
}