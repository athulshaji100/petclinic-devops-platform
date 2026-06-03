resource "aws_ecr_repository" "petclinic" {
  for_each = toset(var.petclinic_services)

  name                 = "petclinic-${each.value}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Project = "petclinic"
    Service = each.value
  }
}