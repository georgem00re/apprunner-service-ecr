
AWS_REGION ?= eu-west-2
AWS_PROFILE ?= admin

terraform-init:
	terraform -chdir=terraform init

terraform-deploy-ecr-repository:
	terraform -chdir=terraform apply -target="module.aws_ecr_repository"

terraform-deploy-apprunner-service:
	terraform -chdir=terraform apply -target="module.aws_apprunner_service"

terraform-get-apprunner-service-url:
	terraform -chdir=terraform output apprunner_service_url

terraform-destroy-all-resources:
	terraform -chdir=terraform destroy

terraform-list-resources:
	terraform -chdir=terraform show

docker-authenticate-client:
	@ECR_REPOSITORY_URL=$$(terraform -chdir=terraform output -raw ecr_repository_url); \
	aws ecr --profile $(AWS_PROFILE) --region $(AWS_REGION) get-login-password | docker login --username AWS --password-stdin $$ECR_REPOSITORY_URL

docker-build-ktor-server-image:
	docker build -t "ktor-server:latest" --platform linux/amd64 ./ktor-server

docker-tag-ktor-server-image:
	@ECR_REPOSITORY_URL=$$(terraform -chdir=terraform output -raw ecr_repository_url); \
	docker tag ktor-server:latest $${ECR_REPOSITORY_URL}:latest

docker-push-ktor-server-image-to-ecr:
	@ECR_REPOSITORY_URL=$$(terraform -chdir=terraform output -raw ecr_repository_url); \
	docker push $${ECR_REPOSITORY_URL}:latest
