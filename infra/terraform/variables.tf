variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

# VPC

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_a_cidr" {
  type = string
}

variable "public_subnet_b_cidr" {
  type = string
}

variable "private_subnet_a_cidr" {
  type = string
}

variable "private_subnet_b_cidr" {
  type = string
}

# EC2

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}


# ECR

variable "petclinic_services" {
  type        = list(string)
  description = "List of Petclinic microservices"

  default = [
    "config-server",
    "discovery-server",
    "api-gateway",
    "customers-service",
    "visits-service",
    "vets-service",
    "admin-server",
    "genai-service"
  ]
}


# EKS

variable "cluster_name" {
  type    = string
  default = "petclinic-eks-cluster"
}


# RDS

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}


