module "eloquent_app_ecr" {
  source             = "../modules/shared"
  repository_name    = "eloquent-app"
  mutable_image_tags = false
  encryption_type    = "AES256"
}