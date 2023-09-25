variable "cloudfront" {
  type = object({
    enabled             = bool
    comment             = string
    default_root_object = string
    aliases             = set(string)

    alb_origin_id   = string
    alb_domain_name = string

    origin_protocol_policy = string
    origin_ssl_protocols   = set(string)

    s3_origin_id           = string
    s3_domain_name         = string
    origin_access_identity = string

    domain_name = string
  })
}

variable "default_cache_behavior" {
  type = object({
    allowed_methods = set(string)
    cached_methods  = set(string)
    min_ttl         = number
    default_ttl     = number
    max_ttl         = number

    target_origin_id       = string
    viewer_protocol_policy = string
    compress               = bool
  })
}

variable "ordered_cache_behavior" {
  type = object({
    path_pattern     = string
    allowed_methods  = set(string)
    cached_methods   = set(string)
    target_origin_id = string

    min_ttl                = number
    default_ttl            = number
    max_ttl                = number
    compress               = bool
    viewer_protocol_policy = string
  })
}

variable "tags" {
  type = map(any)
}