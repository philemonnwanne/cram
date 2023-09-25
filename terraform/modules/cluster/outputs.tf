output "cluster_name" {
  description = "name of the cluster"
  value       = aws_ecs_cluster.tripvibe.name
}

output "cluster_id" {
  description = "ID of the cluster"
  value       = aws_ecs_cluster.tripvibe.id
}