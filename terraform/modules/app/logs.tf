
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "${var.service_name}-log-group"
  retention_in_days = var.cloudwatch_log_retention_in_days
  tags = {
    name = "${var.service_name}-log-group"
  }
}
