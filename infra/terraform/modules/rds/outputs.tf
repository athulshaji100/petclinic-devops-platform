output "rds_endpoint" {
  value = aws_db_instance.petclinic_mysql.address
}

output "rds_port" {
  value = aws_db_instance.petclinic_mysql.port
}

output "rds_db_name" {
  value = aws_db_instance.petclinic_mysql.db_name
}

