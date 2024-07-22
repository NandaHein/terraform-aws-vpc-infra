data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "bastion_host_sg" {
  name        = "sg_for_bastion_host"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.custom-vpc-01.id

  tags = {
    Name = var.bastion_host_sg_name
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "key_gen" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "aws_ec2_key_pairs" {
  key_name   = var.bastion_host_key_name
  public_key = tls_private_key.key_gen.public_key_openssh
}

resource "local_sensitive_file" "ssh_private_key" {
  content         = tls_private_key.key_gen.private_key_openssh
  filename        = var.local_ssh_key_path
  file_permission = "0400"
}

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.bastion_host_instance_type
  tenancy                     = "default"
  subnet_id                   = aws_subnet.public_subnet["public_subnet_02"].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_host_sg.id]
  key_name                    = aws_key_pair.aws_ec2_key_pairs.key_name

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.local_ssh_key_path)
    host        = self.public_ip
  }

  provisioner "file" {
    source      = var.local_ssh_key_path
    destination = "/home/ec2-user/bastion_host.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 '/home/ec2-user/bastion_host.pem'",
    ]

  }
}

resource "aws_eip" "bastion_host_elastic_ip" {
  instance = aws_instance.bastion_host.id
  domain   = "vpc"
}

resource "aws_security_group" "private_instance_sg" {
  name        = "sg_for_private_instance"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.custom-vpc-01.id

  tags = {
    Name = "private instance sg"
  }

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = [aws_security_group.bastion_host_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "private_instance" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.private_instance_instance_type
  tenancy                     = "default"
  subnet_id                   = local.private_subnet_id[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.private_instance_sg.id]
  key_name                    = aws_key_pair.aws_ec2_key_pairs.key_name
}