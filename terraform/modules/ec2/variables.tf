variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
}

variable "instance_type" {
  description = "The EC2 instance type"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
}

variable "public_subnet" {
  description = "The public subnet ID"
}

variable "security_group" {
  description = "The security group ID"
}
