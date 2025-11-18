resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
  
  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.eloquent_services.arn
  }
  tags = {
    Name = var.ecs_cluster_name
  }
}
