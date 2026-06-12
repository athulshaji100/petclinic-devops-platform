resource "aws_secretsmanager_secret" "petclinic_rds_secret" {
  name        = "petclinic/rds-v2"
  description = "PetClinic RDS MySQL credentials"

  kms_key_id = var.kms_key_arn

  tags = {
    Name    = "petclinic-rds-secret"
    Project = "petclinic"
  }
}

resource "aws_secretsmanager_secret_version" "petclinic_rds_secret_value" {
  secret_id = aws_secretsmanager_secret.petclinic_rds_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = var.rds_endpoint
    port     = var.rds_port
    dbname   = var.db_name
    engine   = "mysql"
  })
}