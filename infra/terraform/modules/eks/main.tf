resource "aws_eks_cluster" "petclinic" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = "1.30"

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  tags = {
    Project = "petclinic"
  }
}

resource "aws_eks_node_group" "petclinic" {
  cluster_name    = aws_eks_cluster.petclinic.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.eks_node_role_arn

  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }

  instance_types = ["t3.medium"]

  tags = {
    Project = "petclinic"
  }

  depends_on = [
    aws_eks_cluster.petclinic
  ]
}


resource "aws_eks_access_entry" "jenkins" {
  cluster_name  = aws_eks_cluster.petclinic.name
  principal_arn = var.jenkins_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "jenkins_admin" {
  cluster_name  = aws_eks_cluster.petclinic.name
  principal_arn = var.jenkins_role_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.jenkins
  ]
}