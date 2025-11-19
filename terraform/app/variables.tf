variable "service_name" {
  type = string
}
variable "environment" {
  type = string
}

variable "service_port" {
  type = number
}

variable "region" {
  type        = string
  description = "AWS region"
}
variable "replica_count" {
  type        = number
  description = "Number of desired instances for this service"
}

variable "mem" {
  type = number
}

variable "cpu" {
  type = number
}

variable "min_healthy_percent" {
  type        = number
  description = "Rolling update: Minimum number of instances allowed during deploys"
}

variable "max_healthy_percent" {
  type        = number
  description = "Rolling update: Maximum number of instances allowed during deploys"
}
variable "cloudwatch_log_retention_in_days" {
  type        = number
  description = "Cloudwatch log retention in days"
}
variable "is_internal" {
  description = "Whether the LB is private or not"
  type        = bool
}

variable "enable_https" {
  description = "Whether the LB will listen on the HTTPS port"
  type        = bool
}

variable "enable_http" {
  description = "Whether the LB will listen on the HTTP port"
  type        = bool
  default     = true
}

variable "enable_https_redirection" {
  description = "Whether the LB will redirect HTTP requests to HTTPS"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "Certificate associate with the HTTPS. Only available if enable_https is set to true"
  type        = string
  default     = null
}

variable "allow_ingress_lb_cidr_block" {
  description = "Cidr block to allow connections to enter the ALB"
  type        = list(string)
}

variable "image_tag" {
  type        = string
  description = "Image stored on ECR"
}

variable "role_arn" {type = string}