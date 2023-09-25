output "zone_id" {
  description = "ID of DNS zone"
  value       = data.aws_route53_zone.zone.id
}

output "zone_name" {
  description = "ID of DNS zone"
  value       = data.aws_route53_zone.zone.name
}