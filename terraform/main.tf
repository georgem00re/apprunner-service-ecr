
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

// Fetches a list of currently available availability zones
// in the AWS region your provider is configured for (eu-west-2).
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  apprunner = {
    service_name = "my-apprunner-service"
  }
  availability_zone_a = data.aws_availability_zones.available.names[0]
  availability_zone_b = data.aws_availability_zones.available.names[1]
}

module "aws_ecr_repository" {
  source = "./modules/aws_ecr_repository"
}

module "aws_apprunner_service" {
  source = "./modules/aws_apprunner_service"
}

module "aws_apprunner_auto_scaling_configuration" {
  source = "./modules/aws_apprunner_auto_scaling_configuration_version"
}
