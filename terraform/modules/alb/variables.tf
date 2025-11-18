variable "name" {
  description = "Name to associate to resources"
  type        = string 
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
