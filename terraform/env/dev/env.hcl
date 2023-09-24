# Here we declare common variables for this environment. This is automatically pulled in in the root terragrunt.hcl configuration to feed forward to the child modules.

locals {
  environment = "dev"

  tags = {
    Creator   = "philemonnwanne"
    Date = formatdate("EEEE, DD-MMM-YY ZZZ", timestamp()) # watchout for drift changes if trying to plan/apply after 24 hrs
    Environment = local.environment
  }
}