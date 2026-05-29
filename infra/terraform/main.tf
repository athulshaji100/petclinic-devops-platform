provider "aws" {
  region = var.aws_region
}

# -----------------------------
# VPC MODULE
# -----------------------------

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr

  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr

  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
}


module "iam" {
  source = "./modules/iam"

  jenkins_role_name             = "petclinic-jenkins-role"

  jenkins_instance_profile_name = "petclinic-jenkins-profile"

  eks_cluster_role_name         = "petclinic-eks-cluster-role"

  eks_node_role_name            = "petclinic-eks-node-role"
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