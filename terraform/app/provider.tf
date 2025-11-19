terraform {
  backend "s3" {
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = var.role_arn
  }

  default_tags {
    tags = {
      Environment = var.environment
      Managed_by  = "Terraform"
    }
  }
}
