variable "mutable_image_tags" {
  type        = bool
  description = "Defines whether tags are mutable or immutable"
}

variable "encryption_type" {
  type        = string
  description = "Type of encryption to use"
}

variable "repository_name" {
  type        = string
  description = "Repository Name"
}