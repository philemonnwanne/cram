variable "iam" {
  type = object({
    task_execution_role = string
    resources = set(string)
    task_execution_policy = string
    task_role = string
    task_policy = string
  })
}