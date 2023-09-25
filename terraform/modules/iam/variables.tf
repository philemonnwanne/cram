variable "ecs_policy" {
  type = object({
    task_execution_role   = string
    resources             = set(string)
    task_execution_policy = string
    task_role             = string
    task_policy           = string
  })
}

variable "cloudfront_bucket_policy" {
  type = object({
    bucket    = string
    actions   = set(string)
    resources = set(string)
    comment   = string
  })
}