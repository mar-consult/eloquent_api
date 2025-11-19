resource "aws_ecr_repository" "ecr" {
  name                 = "eloquent/${var.repository_name}"
  image_tag_mutability = var.mutable_image_tags ? "MUTABLE" : "IMMUTABLE"
  encryption_configuration {
    encryption_type = var.encryption_type
  }

  tags = {
    Name = "eloquent/${var.repository_name}"
  }
}



data "aws_iam_policy_document" "ecr_ecs_policy_document" {
  statement {
    sid    = "ECSAccess"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
    ]
  }
}

resource "aws_ecr_repository_policy" "ecr_write_access_policy" {
  repository = aws_ecr_repository.ecr.name
  policy     = data.aws_iam_policy_document.ecr_ecs_policy_document.json
}