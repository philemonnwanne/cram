# Here we declare common variables for this environment. This is automatically pulled in in the root terragrunt.hcl configuration to feed forward to the child modules.

locals {
  environment = "prod"

  tags = {
    Creator = "philemonnwanne"
    Environment = local.environment
  }
}