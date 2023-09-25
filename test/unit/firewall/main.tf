module "firewall" {
  source = "../../../terraform/modules/firewall"

  vpc_id = module.vpc.vpc_id
}