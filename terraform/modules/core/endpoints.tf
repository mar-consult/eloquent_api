resource "aws_security_group" "ecr_vpc_endpoint_sg" {
  name        = "${var.environment}-${var.name}-vpc-endpoint-sg"
  description = "Security group for ECR VPC Endpoints"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.name}-vpc-endpoint-sg"
  }
}

data "aws_iam_policy_document" "ecr_access_policy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"

  subnet_ids         = local.private_subnet_ids
  security_group_ids = [aws_security_group.ecr_vpc_endpoint_sg.id]

  private_dns_enabled = true

  policy = data.aws_iam_policy_document.ecr_access_policy.json
}

resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  subnet_ids         = local.private_subnet_ids
  security_group_ids = [aws_security_group.ecr_vpc_endpoint_sg.id]

  private_dns_enabled = true

  policy = data.aws_iam_policy_document.ecr_access_policy.json

}
