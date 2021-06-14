resource "aws_ecr_repository" "rusk_app" {
  name                 = "rusk_app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}