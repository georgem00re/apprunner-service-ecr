
terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.95.0"
    }
  }

  // Ordinarily, we would want to store the tfstate in an S3 bucket,
  // but for this example, we are using a local backend to keep things simple.
  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "aws" {
  region  = "eu-west-2"
  profile = "admin"
}

locals {
  apprunner = {
    service_name                    = "my-apprunner-service"
    auto_scaling_configuration_name = "my-auto-scaling-configuration"
  }
  ecr = {
    repository_name = "my-ecr-repository"
  }
  application = {
    port = 80
  }
}

module "aws_ecr_repository" {
  source = "./modules/aws_ecr_repository"
  name   = local.ecr.repository_name
}

// This AWS AppRunner service is dependent on a container image stored in the ECR repository (declared above).
// Therefore, you must apply this Terraform infrastructure in stages. You will apply the ECR repository first
// ('terraform apply -target=module.aws_ecr_repository'). Then, you must push the container image to the repository.
// Only when the container image is stored in the ECR repository will you apply the AppRunner service ('terraform
// apply -target=module.aws_apprunner_service').
module "aws_apprunner_service" {
  source                         = "./modules/aws_apprunner_service"
  auto_scaling_configuration_arn = module.aws_apprunner_auto_scaling_configuration.arn
  image_identifier               = "${module.aws_ecr_repository.url}:latest"
  name                           = local.apprunner.service_name
  port                           = local.application.port
  auto_deployments_enabled       = true
  health_check_path              = "/health"
  health_check_protocol          = "HTTP"
  access_role_arn                = module.aws_iam_role.arn
  depends_on                     = [module.aws_iam_role_policy_attachment]
}

module "aws_apprunner_auto_scaling_configuration" {
  source          = "./modules/aws_apprunner_auto_scaling_configuration_version"
  max_concurrency = 100
  max_size        = 25
  min_size        = 1
  name            = local.apprunner.auto_scaling_configuration_name
}

module "aws_iam_role" {
  source = "./modules/aws_iam_role"
}

module "aws_iam_role_policy_attachment" {
  source     = "./modules/aws_iam_role_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
  role_name  = module.aws_iam_role.name
}
