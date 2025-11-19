module "app" {
  source                           = "../modules/app"
  service_name                     = var.service_name
  environment                      = var.environment
  service_port                     = var.service_port
  region                           = var.region
  replica_count                    = var.replica_count
  mem                              = var.mem
  cpu                              = var.cpu
  min_healthy_percent              = var.min_healthy_percent
  max_healthy_percent              = var.max_healthy_percent
  cloudwatch_log_retention_in_days = var.cloudwatch_log_retention_in_days
  is_internal                      = var.is_internal
  enable_https                     = var.enable_https
  enable_http                      = var.enable_http
  enable_https_redirection         = var.enable_https_redirection
  allow_ingress_lb_cidr_block      = var.allow_ingress_lb_cidr_block
  environment_variables = [
    {
      name  = "ENVIRONMENT",
      value = var.environment
    },
    {
      name  = "APP_VERSION",
      value = var.image_tag
    }
  ]
  image_tag = var.image_tag
}