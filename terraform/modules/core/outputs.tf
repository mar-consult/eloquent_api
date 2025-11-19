output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnets" {
  value = {
    ids         = local.public_subnet_ids
    cidr_blocks = local.public_subnet_cidrs
  }
}

output "private_subnets" {
  value = {
    ids         = local.private_subnet_ids
    cidr_blocks = local.private_subnet_cidrs
  }
}

output "service_discovery_namespace_id" {
  value = aws_service_discovery_private_dns_namespace.eloquent_services.id
}
