# ------------------------- Step 0
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = var.ecs_policy.task_execution_role
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# ------------------------- Step 1
# create policy document
data "aws_iam_policy_document" "task_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = var.ecs_policy.resources
  }
}
# --------------------- Step 2
# link policy document to `aws_iam_policy` resource
resource "aws_iam_policy" "task_execution_policy" {
  name        = var.ecs_policy.task_execution_policy
  description = ""
  policy      = data.aws_iam_policy_document.task_execution_policy.json
}

# ----------------------- Step 3
# attaches the `aws_iam_policy` resource policy to the role in sstep 0
resource "aws_iam_role_policy_attachment" "task_execution_role_policy_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_policy.arn
}
# -------------------------

resource "aws_iam_role" "task_role" {
  name               = var.ecs_policy.task_role
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
# ------------------------- Step 1
# create policy document
data "aws_iam_policy_document" "task_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}
# --------------------- Step 2
# link policy documentt to `aws_iam_policy` resource
resource "aws_iam_policy" "task_policy" {
  name        = var.ecs_policy.task_policy
  description = ""
  policy      = data.aws_iam_policy_document.task_policy.json
}

# ----------------------- Step 3
# attach multiple policies with `for_each`
resource "aws_iam_role_policy_attachment" "task_role_policy_attachment" {
  role = aws_iam_role.task_role.name
  for_each = {
    "policy_one" = aws_iam_policy.task_policy.arn,
    # aws_iam_policy.other_policy.arn,

    # Works with AWS Provided policies too!
    "policy_two" = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  }
  policy_arn = each.value
}

# ===============-========================
# CLOUDFRONT BUCKET POLICY

# identity with which the S3 bucket is accessed
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.cloudfront_bucket_policy.comment
}

# policy to allow the CloudFront `oia` to access the objects in the bucket
data "aws_iam_policy_document" "tripvibe_s3_policy" {
  statement {
    actions   = var.cloudfront_bucket_policy.actions
    resources = var.cloudfront_bucket_policy.resources
    # resources = ["${aws_s3_bucket.cloudfront.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "tripvibe_s3_bucket_policy" {
  bucket = var.cloudfront_bucket_policy.bucket
  policy = data.aws_iam_policy_document.tripvibe_s3_policy.json
}
# CLOUDFRONT BUCKET POLICY
# ===============-========================