variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "allowed_ports" {
  description = "List of allowed ports"
  type        = list(number)
}
