variable "name" { type = string }
variable "environment" { type = string }
variable "vpc_cidr_block" { type = string }
variable "region" { type = string }
variable "ecs_cluster_name" { type = string }
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

variable "enable_container_insights" {
  type    = bool
  default = false
}
