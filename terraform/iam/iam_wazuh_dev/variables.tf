variable "role_name" {
  description = "Name for the IAM role"
  type        = string
  default     = "wazuh-ssm-role"
}

variable "instance_profile_name" {
  description = "Name for the IAM instance profile"
  type        = string
  default     = "wazuh-ssm-profile"
}