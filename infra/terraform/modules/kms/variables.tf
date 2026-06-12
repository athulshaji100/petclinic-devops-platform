variable "kms_description" {
  type    = string
  default = "KMS key for PetClinic"
}

variable "kms_alias_name" {
  type    = string
  default = "petclinic-kms"
}

variable "deletion_window_in_days" {
  type    = number
  default = 7
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "petclinic"
}