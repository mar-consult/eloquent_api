resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.environment}/network/vpc/id"
  type  = "String"
  value = aws_vpc.vpc.id
}

resource "aws_ssm_parameter" "public_subnets" {
  name  = "/${var.environment}/network/vpc/subnets/public/ids"
  type  = "String"
  value = jsonencode(local.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnets" {
  name  = "/${var.environment}/network/vpc/subnets/private/ids"
  type  = "String"
  value = jsonencode(local.private_subnet_ids)
}

resource "aws_ssm_parameter" "service_discovery" {
  name  = "/${var.environment}/ecs/namespace/id"
  type  = "String"
  value = aws_service_discovery_private_dns_namespace.eloquent_services.id
}

resource "aws_ssm_parameter" "service_discovery_arn" {
  name  = "/${var.environment}/ecs/namespace/arn"
  type  = "String"
  value = aws_service_discovery_private_dns_namespace.eloquent_services.arn
}

resource "aws_ssm_parameter" "cluster_name" {
  name  = "/${var.environment}/ecs/cluster/name"
  type  = "String"
  value = aws_ecs_cluster.cluster.name
}

resource "aws_ssm_parameter" "cluster_id" {
  name  = "/${var.environment}/ecs/cluster/id"
  type  = "String"
  value = aws_ecs_cluster.cluster.id
}