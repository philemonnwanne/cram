variable "backend_sg" {
  type = object({
    name = string
    from_port          = number
    to_port            = number
    protocol           = string
    cidr_blocks        = string
    egress_cidr_blocks = list(string)
    egress_rules       = list(string)
  })
}

variable "tags" {
  type = map(any)
}

variable "vpc_id" {
  type = string
}

variable "alb_sg" {
  type = object({
    name = string
    alb_ingress_with_cidr_blocks = list(map(string))
    ingress_cidr_blocks          = list(string)
    alb_ingress_rules            = list(any)
    egress_cidr_blocks           = list(string)
    egress_rules                 = list(string)
  })
}