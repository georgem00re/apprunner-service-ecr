
resource "aws_apprunner_service" "this" {
  service_name                   = var.name
  auto_scaling_configuration_arn = var.auto_scaling_configuration_arn

  source_configuration {
    authentication_configuration {
      access_role_arn = var.access_role_arn
    }
    image_repository {
      image_configuration {
        port = var.port
      }
      image_identifier      = var.image_identifier
      image_repository_type = "ECR"
    }
    // Whether continuous integration from the source repository
    // is enabled for the App Runner service. If set to true, each
    // repository change (new image version) starts a deployment.
    auto_deployments_enabled = var.auto_deployments_enabled
  }

  health_check_configuration {
    path     = var.health_check_path
    protocol = var.health_check_protocol
  }
}
