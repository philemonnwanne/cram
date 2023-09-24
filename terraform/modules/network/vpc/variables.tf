variable "vpc" {
  type = object({
    name                 = string
    cidr                 = string
    azs                  = list(string)
    private_subnets      = list(string)
    private_subnet_names = list(string)
    public_subnets       = list(string)
    public_subnet_names  = list(string)
  })
}

variable "tags" {
  type = map(any)
}