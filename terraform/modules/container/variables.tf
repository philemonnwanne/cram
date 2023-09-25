variable "tags" {
  type = map(any)
}

variable "task_definition" {
  type = object({
    family             = string
    execution_role_arn = string
    task_role_arn      = string
    task_name          = string
    ecr_image_uri      = string
    aws_region         = string
    container_port     = number
    protocol           = string
    app_protocol       = string
    log_driver         = string
    secret_manager_arn = string
    bucket             = string
    cpu                = number
    memory             = number
  })
}

variable "cloudwatch_log_group" {
  description = "cloudwatch log-group for container logs"
  type        = string
  default     = "/ecs/backend"
}

variable "service" {
  type = object({
    name             = string
    cluster_id       = string
    security_groups  = set(string)
    subnets          = set(string)
    target_group_arn = string
    container_name   = string
    container_port   = number
  })
}
