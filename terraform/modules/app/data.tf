data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.environment}/network/vpc/id"
}

data "aws_ssm_parameter" "public_subnets" {
  name = "/${var.environment}/network/vpc/subnets/public/ids"
}

data "aws_ssm_parameter" "private_subnets" {
  name = "/${var.environment}/network/vpc/subnets/private/ids"
}

data "aws_ssm_parameter" "namespace" {
  name = "/${var.environment}/ecs/namespace/id"
}

data "aws_ssm_parameter" "repository_url" {
  name = "/eloquent/${var.service_name}/repository/url"
}

data "aws_ssm_parameter" "cluster_name" {
  name = "/${var.environment}/ecs/cluster/name"
}

data "aws_ssm_parameter" "cluster_id" {
  name = "/${var.environment}/ecs/cluster/id"
}

data "aws_ssm_parameter" "namespace_arn" {
  name = "/${var.environment}/ecs/namespace/arn"
}

locals {
  vpc_id          = data.aws_ssm_parameter.vpc_id.value
  public_subnets  = jsondecode(data.aws_ssm_parameter.public_subnets.value)
  private_subnets = jsondecode(data.aws_ssm_parameter.private_subnets.value)
  namespace_id    = data.aws_ssm_parameter.namespace.value
  repository_url  = data.aws_ssm_parameter.repository_url.value
  cluster_name    = data.aws_ssm_parameter.cluster_name.value
  cluster_id      = data.aws_ssm_parameter.cluster_id.value
  namespace_arn   = data.aws_ssm_parameter.namespace_arn.value
}