
resource "aws_apprunner_service" "this" {
  service_name = var.name

  source_configuration {
    image_repository {
      image_configuration {
        port = var.port
      }
      image_identifier = var.image_identifier
      image_repository_type = "ECR_PUBLIC"
    }

    auto_scaling_configuration_arn = var.auto_scaling_configuration_arn

    // Whether continuous integration from the source repository 
    // is enabled for the App Runner service. If set to true, each 
    // repository change (new image version) starts a deployment.
    auto_deployments_enabled = true
  }
}
