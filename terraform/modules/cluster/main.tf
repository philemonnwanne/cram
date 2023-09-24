resource "aws_ecs_cluster" "tripvibe" {
  name = var.ecs-cluster.name
  setting {
    name  = "containerInsights"
    value = var.ecs-cluster.setting["value"]
  }
}