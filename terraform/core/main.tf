module "core" {
  source                    = "../modules/core"
  name                      = var.name
  environment               = var.environment
  vpc_cidr_block            = var.vpc_cidr_block
  region                    = var.region
  ecs_cluster_name          = var.ecs_cluster_name
  public_subnets            = var.public_subnets
  private_subnets           = var.private_subnets
  enable_container_insights = var.enable_container_insights
}