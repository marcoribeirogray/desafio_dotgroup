output "cluster_name" {
  description = "Nome do cluster ECS"
  value       = module.ecs.cluster_name
}

output "service_name" {
  description = "Nome do serviço ECS"
  value       = module.ecs.service_name
}

output "load_balancer_dns" {
  description = "Endpoint público do ALB"
  value       = module.alb.load_balancer_dns
}
