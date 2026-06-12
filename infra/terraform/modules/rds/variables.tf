variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "eks_node_security_group_id" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "db_name" {
  type    = string
  default = "petclinic"
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "project_name" {
  type    = string
  default = "petclinic"
}