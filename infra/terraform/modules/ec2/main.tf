resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  associate_public_ip_address = true

  iam_instance_profile   = var.iam_instance_profile

  user_data = file("${path.module}/user_data.sh")


  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

                                                                
  tags = {
    Name = "petclinic-ec2"
  }
}                                                                                    