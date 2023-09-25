resource "aws_ecs_task_definition" "backend" {
  tags   = var.tags
  family = var.task_definition.family
  execution_role_arn    = var.task_definition.execution_role_arn
  task_role_arn         = var.task_definition.task_role_arn
  container_definitions = jsonencode([{
    name = var.task_definition.task_name
    # image     =  var.task_definition.ecr_image_uri
    image     = "${var.task_definition.ecr_image_uri}.ecr.${var.task_definition.aws_region}.amazonaws.com/${var.task_definition.task_name}"
    essential = true
    healthCheck = {
      command     = ["CMD-SHELL", "npm --version || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 60
    }
    portMappings = [{
      containerPort = var.task_definition.container_port
      protocol      = var.task_definition.protocol
      appProtocol   = var.task_definition.app_protocol
    }]
    logConfiguration = {
      logDriver = var.task_definition.log_driver
      options = {
        awslogs-region        = var.task_definition.aws_region
        awslogs-group         = var.cloudwatch_log_group
        awslogs-stream-prefix = "ecs"
      }
    }
    environment = [{
      name  = "S3_BUCKET_NAME"
      value = var.task_definition.bucket
      },
      { name  = "FRONTEND_URL"
        value = "*"
      },
      { name  = "BACKEND_URL"
        value = "*"
      },
      { name  = "AWS_REGION"
        value = var.task_definition.aws_region
    }]
    secrets = [{
      name      = "AWS_ACCESS_KEY_ID"
      valueFrom = "${var.task_definition.secret_manager_arn}/AWS_ACCESS_KEY_ID"
      },
      {
        name      = "AWS_SECRET_ACCESS_KEY"
        valueFrom = "${var.task_definition.secret_manager_arn}/AWS_SECRET_ACCESS_KEY"
      },
      {
        name      = "JWT_TOKEN"
        valueFrom = "${var.task_definition.secret_manager_arn}/JWT_TOKEN"
      },
      {
        name      = "MONGO_URL"
        valueFrom = "${var.task_definition.secret_manager_arn}/MONGO_URL"
    }]
  }])
  # These are the minimum values for Fargate containers.
  cpu                      = var.task_definition.cpu
  memory                   = var.task_definition.memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
}

resource "aws_cloudwatch_log_group" "backend" {
  name = var.cloudwatch_log_group
}

resource "aws_ecs_service" "backend" {
  name            = var.service.name
  task_definition = aws_ecs_task_definition.backend.arn
  cluster         = var.service.cluster_id
  launch_type     = "FARGATE"
  desired_count   = 1

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition
    ]
  }
  enable_ecs_managed_tags = true
  network_configuration {
    assign_public_ip = true
    security_groups  = var.service.security_groups
    subnets          = var.service.subnets
  }
  load_balancer {
    target_group_arn = var.service.target_group_arn
    container_name = var.service.container_name
    container_port = var.service.container_port
  }
  tags = var.tags
}
