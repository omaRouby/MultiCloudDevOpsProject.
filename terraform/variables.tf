variable "key_name" {
  description = "The name of the key pair to use for SSH access"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
}

variable "instance_type" {
  description = "The EC2 instance type"
}

variable "alarm_action_arn" {
  description = "The ARN of the SNS topic or action to take when an alarm state is reached"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}
