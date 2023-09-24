variable "ecs-cluster" {
  type = object({
    name    = string
    setting = map(any)
  })
}

variable "tags" {
  type = map(any)
}