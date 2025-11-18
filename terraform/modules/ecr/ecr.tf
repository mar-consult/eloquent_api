resource "aws_ecr_repository" "ecr" {
  name                 = var.repository_name
  image_tag_mutability = var.mutable_image_tags ? "MUTABLE" : "IMMUTABLE"
  encryption_configuration {
    encryption_type = var.encryption_type
  }

  tags = {
    Name       = var.repository_name
  }
}
