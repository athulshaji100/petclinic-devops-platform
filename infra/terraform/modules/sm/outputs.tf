output "secret_name" {
  value = aws_secretsmanager_secret.petclinic_rds_secret.name
}

output "secret_arn" {
  value = aws_secretsmanager_secret.petclinic_rds_secret.arn
}