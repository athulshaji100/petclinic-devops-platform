variable "kms_key_arn" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "rds_endpoint" {
  type = string
}

variable "rds_port" {
  type    = number
  default = 3306
}

variable "db_name" {
  type    = string
  default = "petclinic"
}