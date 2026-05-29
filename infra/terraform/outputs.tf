# VPC

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_a_id" {
  value = module.vpc.public_subnet_a_id
}

output "public_subnet_b_id" {
  value = module.vpc.public_subnet_b_id
}

output "private_subnet_a_id" {
  value = module.vpc.private_subnet_a_id
}

output "private_subnet_b_id" {
  value = module.vpc.private_subnet_b_id
}

# EC2

output "instance_id" {
  value = module.ec2.instance_id
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "private_ip" {
  value = module.ec2.private_ip
}
output "jenkins_instance_profile_name" {

  value = module.iam.jenkins_instance_profile_name
}

output "eks_cluster_role_arn" {

  value = module.iam.eks_cluster_role_arn
}

output "eks_node_role_arn" {

  value = module.iam.eks_node_role_arn
}

