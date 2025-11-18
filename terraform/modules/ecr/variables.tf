variable "repository_name" {
  type        = string
  description = "Name of repository"
}

variable "mutable_image_tags" {
  type        = bool
  description = "Defines whether tags are mutable or immutable"
}

variable "encryption_type" {
  type        = string
  description = "Type of encryption to use"
  default     = "AES256"
}

variable "management_cicd_role_arn" {
  type        = string
  description = "ARN of cicd role from management account"
}

variable "enable_dev_read_access" {
  type        = bool
  description = "Give everyone in the organization read access to the repositories"
  default     = false
}

variable "enable_dev_write_access" {
  type        = bool
  description = "Give everyone in the organization write access to the repositories"
  default     = false
}
