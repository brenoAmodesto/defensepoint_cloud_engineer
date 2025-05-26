variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environmentdev" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "environmentstag" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "stag"
}


variable "environmentprod" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}


