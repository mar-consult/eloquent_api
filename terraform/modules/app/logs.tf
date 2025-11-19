
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "${local.service_name}-log-group"
  retention_in_days = var.cloudwatch_log_retention_in_days
  tags = {
    name = "${local.service_name}-log-group"
  }
}
