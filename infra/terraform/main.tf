provider "aws" {
  region = var.aws_region
}

// Added missing variable declaration for db_name
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "petclinic"
}

# -----------------------------
# VPC MODULE
# -----------------------------

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr

  public_subnet_a_cidr = var.public_subnet_a_cidr
  public_subnet_b_cidr = var.public_subnet_b_cidr

  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
}


module "iam" {
  source = "./modules/iam"

  jenkins_role_name = "petclinic-jenkins-role"

  jenkins_instance_profile_name = "petclainic-jenkins-profile"

  eks_cluster_role_name = "petclinic-eks-cluster-role"

  eks_node_role_name = "petclinic-eks-node-role"
}



# -----------------------------
# EC2 MODULE
# -----------------------------

# -----------------------------
# EC2 MODULE
# -----------------------------

module "ec2" {
  source = "./modules/ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id         = module.vpc.public_subnet_a_id
  security_group_id = module.vpc.security_group_id

  iam_instance_profile = module.iam.jenkins_instance_profile_name
}




# -----------------------------
# ECR MODULE
# -----------------------------

module "ecr" {
  source = "./modules/ecr"

  petclinic_services = var.petclinic_services
}


# -----------------------------
# EKS MODULE
# -----------------------------


module "eks" {
  source = "./modules/eks"

  cluster_name         = var.cluster_name
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn
  jenkins_role_arn     = module.iam.jenkins_role_arn

  private_subnet_ids = [
    module.vpc.private_subnet_a_id,
    module.vpc.private_subnet_b_id
  ]
}


# -----------------------------
# KMS MODULE
# -----------------------------


module "kms" {
  source = "./modules/kms"

  environment  = "dev"
  project_name = "petclinic"
}


# -----------------------------
# RDS MODULE
# -----------------------------


module "rds" {
  source = "./modules/rds"

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = [
    module.vpc.private_subnet_a_id,
    module.vpc.private_subnet_b_id
  ]

  eks_node_security_group_id = module.eks.cluster_security_group_id

  kms_key_arn = module.kms.kms_key_arn

  db_username = var.db_username
  db_password = var.db_password
}


# -----------------------------
# RDS MODULE
# -----------------------------



module "secrets_manager" {
  source = "./modules/sm"

  kms_key_arn = module.kms.kms_key_arn

  db_username  = var.db_username
  db_password  = var.db_password
  rds_endpoint = module.rds.rds_endpoint
  rds_port     = module.rds.rds_port
  db_name      = var.db_name
}

# -----------------------------
# EXTERNAL SECRETS IRSA MODULE
# -----------------------------



module "external_secrets_irsa" {
  source = "./modules/external-secrets-irsa"

  cluster_name = module.eks.cluster_name
  secret_arn   = module.secrets_manager.secret_arn
  kms_key_arn  = module.kms.kms_key_arn

  depends_on = [
    module.eks,
    module.secrets_manager,
    module.kms
  ]
}