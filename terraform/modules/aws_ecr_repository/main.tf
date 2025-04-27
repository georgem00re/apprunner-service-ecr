
resource "aws_ecr_repository" "this" {
  name = var.name

  // If true, will delete the repository even if it contains images.
  // We set this to true so that Terraform can always delete the repository.
  force_delete = true
}
