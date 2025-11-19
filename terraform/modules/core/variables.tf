variable "name" {
  type        = string
  description = "VPC name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "enable_container_insights" {
  type        = bool
  description = "Whether to enable or not container insights"
}
variable "region" {
  type = string
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for VPC"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS"
  default     = true
}

variable "public_subnets" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}
