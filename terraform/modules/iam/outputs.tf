output "execution_role_arn" {
  value = aws_iam_role.task_execution_role.arn
}

output "task_role_arn" {
  value = aws_iam_role.task_role.arn
}

output "origin_access_identity" {
  value = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
}