resource "aws_kms_key" "petclinic_kms" {
  description             = var.kms_description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = true

  tags = {
    Name        = var.kms_alias_name
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_kms_alias" "petclinic_kms_alias" {
  name          = "alias/${var.kms_alias_name}"
  target_key_id = aws_kms_key.petclinic_kms.key_id
}