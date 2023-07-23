# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# EC2 Instance
resource "aws_instance" "myec2" {
  ami                         = data.aws_ami.amzlinux2.id
  instance_type               = var.instance_type
  user_data                   = file("${path.module}/app1-install.sh")
  key_name                    = "terraform_key"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.private[0].id
  vpc_security_group_ids      = [aws_security_group.grad_proj_sg["ssh"].id, aws_security_group.grad_proj_sg["http_https"].id, aws_security_group.grad_proj_sg["public"].id] 
  tags = {
    "Name" = "${var.name}_ec2"
  }
}
resource "aws_instance" "myec2_public" {
  ami                         = data.aws_ami.amzlinux2.id
  instance_type               = var.instance_type
  user_data                   = file("${path.module}/app1-install.sh")
  key_name                    = "terraform_key"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.grad_proj_sg["ssh"].id, aws_security_group.grad_proj_sg["http_https"].id, aws_security_group.grad_proj_sg["public"].id] 
  tags = {
    "Name" = "${var.name}_public_ec2"
  }
}


# EC2 Instance
resource "aws_instance" "main" {
  ami                         = data.aws_ami.amzlinux2.id
  instance_type               = var.instance_type
  user_data                   = file("${path.module}/app1-install.sh")
  key_name                    = "terraform_key"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.main_private[0].id
  vpc_security_group_ids      = [aws_security_group.main.id]
  tags = {
    "Name" = "main_ec2"
  }
}
resource "aws_instance" "main_public" {
  ami                         = data.aws_ami.amzlinux2.id
  instance_type               = var.instance_type
  user_data                   = file("${path.module}/app1-install.sh")
  key_name                    = "terraform_key"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.main_public[0].id
  vpc_security_group_ids      = [aws_security_group.main.id]
  tags = {
    "Name" = "main_public_ec2"
  }
}


