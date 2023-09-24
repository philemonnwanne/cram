# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.

locals {
  aws_region   = "us-east-1"
  project-name = "cram"
  account-id   = 183066416469
  domain-name  = "philemonnwanne.me"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::183066416469:role/sudophil"
  }
  allowed_account_ids = ["${local.account-id}"]
}
EOF
}

// remote_state {
//   backend = "s3"
//   generate = {
//     path      = "backend.tf"
//     if_exists = "overwrite"
//   }
//   config = {
//     skip_bucket_versioning         = true 
//     bucket         = "${local.project-name}-terraform-state"
//     key            = "${path_relative_to_include()}/terraform.tfstate"
//     region         = "${local.aws_region}"
//     encrypt        = true
//     dynamodb_table = "${local.project-name}-lock-table"
//   }
// }