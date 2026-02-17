variable "secret_key" {
  description = "Enter the AWS secret key"
  sensitive   = true
}

variable "access_key" {
  description = "Enter the AWS access key"
  sensitive   = true
}

variable "region" {
  description = "Enter the AWS region (us-east-1 by default)"
  default     = "us-east-1"
}

variable "public_key" {
  description = "Enter the public SSH key"
}

variable "pubkey_name" {
  description = "Enter the name of the public SSH key"
}

variable "az" {
  description = "Enter availability zone (us-east-1a by default)"
  default     = "us-east-1a"
}

variable "allow_tcp_ports" {
  description = "Enter TCP ports to allow connections to (22 by default)"
  default     = [22]
  type        = list(number)
}

variable "vm_template" {
  description = "Enter the AMI ID to create a VM from (Amazon Linux 2 by default)"
  default     = "ami-0c55b159cbfafe1f0"
}

variable "vm_instance_type" {
  description = "Enter the instance type for a VM (t3.medium by default)"
  default     = "t3.medium"
}
