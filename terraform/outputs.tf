
output "apprunner_service_url" {
  value = module.aws_apprunner_service.url
}

output "ecr_repository_url" {
  value = module.aws_ecr_repository.url
}

output "ecr_repository_name" {
  value = module.aws_ecr_repository.name
}
