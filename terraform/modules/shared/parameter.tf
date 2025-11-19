resource "aws_ssm_parameter" "repository_url" {
  name  = "/eloquent/${var.repository_name}/repository/url"
  type  = "String"
  value = aws_ecr_repository.ecr.repository_url
}
