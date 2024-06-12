resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.public_subnet
  security_groups = [var.security_group]

  tags = {
    Name = "Ansible-Deployment-Instance"
  }
}

