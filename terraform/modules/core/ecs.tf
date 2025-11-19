resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-${var.ecs_cluster_name}"

  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.eloquent_services.arn
  }

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
  tags = {
    Name = "${var.environment}-${var.ecs_cluster_name}"
  }
}
