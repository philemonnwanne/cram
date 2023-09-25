# modules/dns/main.tf
data "aws_route53_zone" "zone" {
  zone_id      = var.zone_id
  private_zone = false
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_id = data.aws_route53_zone.zone.zone_id

  records = [
    {
      allow_overwrite = var.record_one.allow_overwrite
      name            = var.record_one.name
      type            = "A"
      alias = {
        name    = var.record_one.cloudfront_alias_name
        zone_id = var.record_one.cloudfront_alias_zone_id
      }
    },
    {
      allow_overwrite = var.record_two.allow_overwrite
      name            = var.record_two.name
      type            = "A"
      alias = {
        name    = var.record_two.alb_alias_name
        zone_id = var.record_two.alb_alias_zone_id
      }
    }
  ]
}