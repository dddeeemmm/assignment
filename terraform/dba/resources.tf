resource "aws_vpc" "vpc" {
  cidr_block           = "172.16.20.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "assignment-dba"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "assignment-dba"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "assignment-dba"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "subnet" {
  availability_zone = var.az
  cidr_block        = aws_vpc.vpc.cidr_block
  vpc_id            = aws_vpc.vpc.id
  depends_on        = [aws_vpc.vpc]

  tags = {
    Name = "assignment-dba"
  }
}

resource "aws_key_pair" "pubkey" {
  key_name   = var.pubkey_name
  public_key = var.public_key
}

resource "aws_security_group" "ssh" {
  vpc_id      = aws_vpc.vpc.id
  name        = "ssh"
  description = "assignment-dba"

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
    Name = "assignment-dba"
  }
}

resource "aws_instance" "vm" {
  ami                         = var.vm_template
  instance_type               = var.vm_instance_type
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  key_name                    = var.pubkey_name
  associate_public_ip_address = true
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  depends_on = [
    aws_subnet.subnet,
    aws_security_group.ssh,
    aws_key_pair.pubkey,
    aws_route_table_association.public,
  ]

  tags = {
    Name = "assignment-dba"
  }
}
