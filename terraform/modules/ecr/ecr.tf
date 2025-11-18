locals {
  root_org_id = data.aws_organizations_organization.org.id
}

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

data "aws_iam_policy_document" "ecr_management_policy_document" {
  statement {
    sid    = "ManagementAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.management_cicd_role_arn]
    }

    actions = [
      "ecr:*",
    ]
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

data "aws_iam_policy_document" "ecr_readonly_access_policy_document" {
  override_policy_documents = [data.aws_iam_policy_document.ecr_management_policy_document.json,
  data.aws_iam_policy_document.ecr_ecs_policy_document.json]

  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalOrgID"
      values   = [local.root_org_id]
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

data "aws_iam_policy_document" "ecr_write_access_policy_document" {
  override_policy_documents = [data.aws_iam_policy_document.ecr_management_policy_document.json,
  data.aws_iam_policy_document.ecr_ecs_policy_document.json]

  statement {
    sid    = "WriteAccess"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalOrgID"
      values   = [local.root_org_id]
    }

    actions = [
      "ecr:*",
    ]
  }
}

resource "aws_ecr_repository_policy" "ecr_write_access_policy" {
  count = var.enable_dev_write_access ? 1 : 0

  repository = aws_ecr_repository.ecr.name
  policy     = data.aws_iam_policy_document.ecr_write_access_policy_document.json
}

resource "aws_ecr_repository_policy" "ecr_read_access_policy" {
  count = var.enable_dev_read_access && !var.enable_dev_write_access ? 1 : 0

  repository = aws_ecr_repository.ecr.name
  policy     = data.aws_iam_policy_document.ecr_readonly_access_policy_document.json
}
