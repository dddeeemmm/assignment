resource "aws_vpc" "vpc" {
  cidr_block           = "172.16.8.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "assignment"
  }
}

resource "aws_subnet" "subnet" {
  availability_zone = var.az
  cidr_block        = aws_vpc.vpc.cidr_block
  vpc_id            = aws_vpc.vpc.id
  depends_on        = [aws_vpc.vpc]

  tags = {
    Name = "assignment"
  }
}

resource "aws_key_pair" "pubkey" {
  key_name   = var.pubkey_name
  public_key = var.public_key
}

resource "aws_eip" "eips" {
  count      = var.eips_count
  domain     = "vpc"  # Updated for AWS terminology
  depends_on = [aws_vpc.vpc]

  tags = {
    Name = "assignment"
  }
}

resource "aws_security_group" "ext" {
  vpc_id      = aws_vpc.vpc.id
  name        = "ext"
  description = "assignment"

  dynamic "ingress" {
    iterator  = port
    for_each  = var.allow_tcp_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_vpc.vpc]

  tags = {
    Name = "assignment"
  }
}

resource "aws_instance" "vms" {
  count                       = var.vms_count
  ami                         = var.vm_template
  instance_type               = var.vm_instance_type
  subnet_id                   = aws_subnet.subnet.id
  private_ip                  = "172.16.8.100"
  vpc_security_group_ids      = [aws_security_group.ext.id]
  key_name                    = var.pubkey_name
  associate_public_ip_address = true
  monitoring                  = true

  depends_on = [
    aws_subnet.subnet,
    aws_security_group.ext,
    aws_key_pair.pubkey,
  ]

  tags = {
    Name = "assignment"
  }
}