resource "aws_vpc" "vpc" {
  # Specify an IP address for the VPC network in CIDR notation (IP/Prefix)
  cidr_block         = "172.16.8.0/24"
  # Enable support for the domain name resolution using CROC Cloud DNS servers
  enable_dns_support = true

  # Assign the Name tag to the created resource
  tags = {
    Name = "My project"
  }
}

resource "aws_subnet" "subnet" {
  # Specify the availability zone, in which the subnet will be created
  # Take its value from the az variable
  availability_zone = var.az
  # Use the same CIDR block of IP addresses for the subnet as for the VPC
  cidr_block        = aws_vpc.vpc.cidr_block
  # Specify the VPC where the subnet will be created
  vpc_id            = aws_vpc.vpc.id
  # Create a subnet only after creating a VPC
  depends_on        = [aws_vpc.vpc]

  # Include the az variable value and the Name tag for the VPC in the Name tag for the subnet
  tags = {
    Name = "Subnet in ${var.az} for ${lookup(aws_vpc.vpc.tags, "Name")}"
  }
}

resource "aws_eip" "eips" {
  # Specify the number of allocated EIPs in the eips_count variable –
  # this allows you to immediately allocate the required number of EIPs.
  # In our case, the address is allocated to the first server only
  count = var.eips_count
  # Allocate within our VPC
  vpc = true
  # and only after the VPC creation
  depends_on = [aws_vpc.vpc]

  # Take the host name of the future VM from the hostnames variable with the array index
  # as the value of the Name tag
  tags = {
    Name = "${var.hostnames[count.index]}"
  }
}

# Create a security group to enable access from the outside
resource "aws_security_group" "ext" {
  # Within our VPC
  vpc_id = aws_vpc.vpc.id
  # specify the security group name
  name = "ext"
  # and description
  description = "External SG"

  # Define inbound rules
  dynamic "ingress" {
    # Specify the name of the variable, which will be used
    # to iterate over all given ports
    iterator = port
    # Iterate over ports from the allow_tcp_ports port list
    for_each = var.allow_tcp_ports
    content {
      # Set the range of ports (in our case, it consists of one port),
      from_port = port.value
      to_port   = port.value
      # protocol,
      protocol = "tcp"
      # and source IP address in CIDR notation (IP/Prefix)
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Define an outbound rule to enable all outbound IPv4 traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_vpc.vpc]

  tags = {
    Name = "External SG"
  }
}

resource "aws_instance" "vms" {
  # Take the number of VMs to create from the vms_count variable
  count = var.vms_count
  # the image ID to create the instance is taken from the vm_template variable
  ami = var.vm_template
  # the instance type of the VM to be created is taken from the vm_instance_type variable
  instance_type = var.vm_instance_type
  # Assign the instance an internal IP address from the previously created subnet in the VPC
  subnet_id = aws_subnet.subnet.id
  # Connect the internal security group to the created instance
  vpc_security_group_ids = [aws_security_group.ext.id]
  # Add the previously created public SSH key to the server
  key_name = var.pubkey_name
  # Do not allocate or assign an external Elastic IP to the instance
  associate_public_ip_address = true
  # Activate monitoring of the instance
  monitoring = true

  # Create an instance only after the creation of:
  # — subnet
  # — internal security group
  depends_on = [
    aws_subnet.subnet,
    aws_security_group.ext,
  ]

  tags = {
    Name = "VM for ${var.hostnames[count.index]}"
  }

  # Create a volume to be attached to an instance
  ebs_block_device {
    # Instruct the system to delete the volume along with the instance
    delete_on_termination = true
    # Specify the device name in the format "disk<N>",
    device_name = "disk1"
    # its type
    volume_type = var.vm_volume_type
    # and size
    volume_size = var.vm_volume_size

    tags = {
      Name = "Disk for ${var.hostnames[count.index]}"
    }
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  # Get the external security group ID
  security_group_id    = aws_security_group.ext.id
  # and the network interface ID of the first instance
  network_interface_id = aws_instance.vms[0].primary_network_interface_id
  # Assign a security group only after the creation of
  # respective instance and security group
  depends_on = [
    aws_instance.vms,
    aws_security_group.ext,
  ]
}

resource "aws_eip_association" "eips_association" {
  # Get the number of created EIPs
  count         = var.eips_count
  # and assign each of them to instances one by one
  instance_id   = element(aws_instance.vms.*.id, count.index)
  allocation_id = element(aws_eip.eips.*.id, count.index)
}