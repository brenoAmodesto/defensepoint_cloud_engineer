output "role_name" {
  description = "IAM Role name"
  value       = aws_iam_role.ssm_role.name
}

output "instance_profile_name" {
  description = "IAM Instance Profile name"
  value       = aws_iam_instance_profile.ssm_profile.name
}

output "instance_profile_arn" {
  description = "IAM Instance Profile ARN"
  value       = aws_iam_instance_profile.ssm_profile.arn
}