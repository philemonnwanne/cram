# modules/loadbalancer/main.tf
resource "aws_lb_target_group" "alb_tg" {
  name        = var.target_group.name
  port        = var.target_group.port
  protocol    = var.target_group.protocol
  target_type = var.target_group.target_type
  vpc_id      = var.target_group.vpc_id
  health_check {
    enabled = true
    path    = "/api"
  }
  tags = var.tags
  # depends_on = [aws_alb.alb]
}

resource "aws_alb" "alb" {
  name               = var.alb.name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.alb.subnets
  security_groups    = var.alb.security_groups
  # depends_on = [aws_internet_gateway.igw]
  tags = var.tags
}

resource "aws_alb_listener" "alb_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = var.alb_http_listener.port
  protocol          = var.alb_http_listener.protocol
  # default_action {
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.alb_tg.arn
  # }

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = var.tags
}

resource "aws_lb_listener" "alb_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = var.alb_https_listener.port
  protocol          = var.alb_https_listener.protocol
  ssl_policy        = var.alb_https_listener.ssl_policy
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
  tags = var.tags
}

# find an issued certificate
data "aws_acm_certificate" "issued" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
  tags     = var.tags
}