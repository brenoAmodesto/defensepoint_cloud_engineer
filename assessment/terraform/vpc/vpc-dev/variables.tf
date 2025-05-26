variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for private subnet A"
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for private subnet B"
}

variable "az_a" {
  description = "Availability Zone for subnet A"
}

variable "az_b" {
  description = "Availability Zone for subnet B"
}

variable "environment" {
  description = "Environment name (e.g., dev, stag, prod)"
}