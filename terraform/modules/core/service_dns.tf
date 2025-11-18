resource "aws_service_discovery_private_dns_namespace" "eloquent_services" {
  name = "eloquent-services"
  vpc  = aws_vpc.vpc.id
}
