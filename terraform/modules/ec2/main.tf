# Generate SSH key (only if at least 1 instance is requested)
resource "tls_private_key" "ssh" {
  count    = var.instance_count > 0 ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  count      = var.instance_count > 0 ? 1 : 0
  key_name   = var.ssh_key_name
  public_key = tls_private_key.ssh[0].public_key_openssh
}

resource "aws_s3_object" "private_key_upload" {
  count   = var.instance_count > 0 ? 1 : 0
  bucket  = var.key_s3_bucket
  key     = "${var.ssh_key_name}.pem"
  content = tls_private_key.ssh[0].private_key_pem
}

# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "ansible-lab-sg"
  description = "Allow SSH for first, restrict others"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ansible Control Node (First EC2)
resource "aws_instance" "control_node" {
  count                  = var.instance_count > 0 ? 1 : 0
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = element(var.subnet_ids, 0)
  key_name               = aws_key_pair.generated[0].key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.ssh[0].private_key_pem
      host        = self.public_ip
    }

    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install epel -y",
      "sudo yum install docker -y"
    ]
  }

  tags = {
    Name = "docker-node"
  }
}

# Managed Nodes (EC2-2 and EC2-3)
resource "aws_instance" "ec2" {
  count                  = var.instance_count > 1 ? var.instance_count - 1 : 0
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = element(var.subnet_ids, count.index + 1)
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "ansible-managed-node-${count.index + 2}"
  }
}

