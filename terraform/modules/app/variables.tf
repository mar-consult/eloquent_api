variable "service_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "service_port" {
  type = number
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "ecs_cluster_id" {
  type        = string
  description = "ID of ECS cluster"
}

variable "ecs_task_execution_role_arn" {
  type        = string
  description = "ARN of role that service will use for execution"
}

variable "ecr_url" {
  type        = string
  description = "URL of ECR repository"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet ids"
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

variable "alb_listener_arn" {
  type = string
}

variable "min_healthy_percent" {
  type        = number
  description = "Rolling update: Minimum number of instances allowed during deploys"
}

variable "max_healthy_percent" {
  type        = number
  description = "Rolling update: Maximum number of instances allowed during deploys"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks of private subnets"
}

variable "service_discovery_namespace_id" {
  type = string
}

variable "cloudwatch_log_retention_in_days"{
  type = number
  description = "Cloudwatch log retention in days"
}

variable "public_subnet_ids" {
  description = "List containing public subnets ids to associate to."
  type    = list(string)
  default = []
}

variable "private_subnet_ids" {
  description = "List containing private subnets ids to associate to."
  type = list(string)
  default = []
}

variable "is_internal" {
  description = "Whether the LB is private or not"
  type = bool
}

variable "enable_https" {
  description = "Whether the LB will listen on the HTTPS port"
  type = bool
}

variable "enable_http" {
  description = "Whether the LB will listen on the HTTP port"
  type = bool
  default = true
}

variable "enable_https_redirection" {
  description = "Whether the LB will redirect HTTP requests to HTTPS"
  type = bool
  default = false
}

variable "certificate_arn" {
  description = "Certificate associate with the HTTPS"
  type = string
  default = null
}

variable "allow_ingress_lb_cidr_block" {
  description = "Cidr block to allow connections to enter the ALB"
  type        = list(string)
}

variable "environment_variables" {
  description = "Cidr block to allow connections to enter the ALB"
  type        = list(object({
    name  = string
    value = string
  }))
}