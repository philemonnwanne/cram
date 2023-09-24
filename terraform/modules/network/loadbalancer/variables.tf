variable "target_group" {
  type = object({
    name        = string
    port        = number
    protocol    = string
    target_type = string
    vpc_id      = string
  })
}

variable "tags" {
  type = map(any)
}

variable "alb" {
  type = object({
    name            = string
    subnets         = set(string)
    security_groups = set(string)
  })
}

variable "alb_http_listener" {
  type = object({
    port     = number
    protocol = string
  })
}

variable "alb_https_listener" {
  type = object({
    port       = number
    protocol   = string
    ssl_policy = string
  })
}

variable "domain_name" {
  type = string
}
