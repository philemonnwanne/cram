# modules/vpc/main.tf
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name                 = var.vpc.name
  cidr                 = var.vpc.cidr
  azs                  = var.vpc.azs
  private_subnets      = var.vpc.private_subnets
  private_subnet_names = var.vpc.private_subnet_names
  public_subnets       = var.vpc.public_subnets
  public_subnet_names  = var.vpc.public_subnet_names
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}