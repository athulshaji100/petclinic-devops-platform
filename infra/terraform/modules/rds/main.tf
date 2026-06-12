resource "aws_db_subnet_group" "petclinic_db_subnet_group" {
  name       = "petclinic-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name    = "petclinic-db-subnet-group"
    Project = var.project_name
  }
}

resource "aws_security_group" "petclinic_rds_sg" {
  name        = "petclinic-rds-sg"
  description = "Allow MySQL access from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from EKS Nodes"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "petclinic-rds-sg"
    Project = var.project_name
  }
}

resource "aws_db_instance" "petclinic_mysql" {
  identifier = "petclinic-mysql"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  storage_encrypted = true
  kms_key_id        = var.kms_key_arn

  db_subnet_group_name   = aws_db_subnet_group.petclinic_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.petclinic_rds_sg.id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name    = "petclinic-mysql"
    Project = var.project_name
  }
}