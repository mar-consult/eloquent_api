resource "aws_service_discovery_service" "eloquent" {
  name = local.service_name

  dns_config {
    namespace_id = local.namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
