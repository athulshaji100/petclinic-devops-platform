output "kms_key_id" {
  value = aws_kms_key.petclinic_kms.key_id
}

output "kms_key_arn" {
  value = aws_kms_key.petclinic_kms.arn
}

output "kms_alias" {
  value = aws_kms_alias.petclinic_kms_alias.name
}