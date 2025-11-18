data "aws_iam_policy_document" "flow_logs_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "flow_logs_role" {
  name               = "vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume_policy.json
  tags = {
    Name = "${var.name}-iam-vpc-flow-logs-role"
  }
}


data "aws_iam_policy_document" "flow_logs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "flow_logs_policy" {
  name        = "vpc-flow-logs-policy"
  description = "Allow flow logs to write to cloudwatch"
  policy      = data.aws_iam_policy_document.flow_logs_policy.json
}

resource "aws_iam_role_policy_attachment" "flow_logs_policy" {
  role       = aws_iam_role.flow_logs_role.name
  policy_arn = aws_iam_policy.flow_logs_policy.arn
}
