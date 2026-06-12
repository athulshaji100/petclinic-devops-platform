output "cluster_name" {
  value = aws_eks_cluster.petclinic.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.petclinic.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.petclinic.arn
}

output "node_group_name" {
  value = aws_eks_node_group.petclinic.node_group_name
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = aws_eks_cluster.petclinic.vpc_config[0].cluster_security_group_id
}