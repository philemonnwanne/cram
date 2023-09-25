variable "zone_id" {
  type = string
}

variable "record_one" {
  type = object({
    allow_overwrite          = bool
    name                     = string
    cloudfront_alias_name    = string
    cloudfront_alias_zone_id = string
  })
}

variable "record_two" {
  type = object({
    allow_overwrite   = bool
    name              = string
    alb_alias_name    = string
    alb_alias_zone_id = string
  })
}