terraform {
  backend "s3" {
    encrypt = true
    bucket  = "eloquent-dev-bucket-tfstate"
    key     = "shared/terraform.tfstate"
    region  = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.21.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "shared"
      Managed_by  = "Terraform"
    }
  }
}
