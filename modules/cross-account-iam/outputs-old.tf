# Cross-Account IAM Module Outputs
# Enterprise-grade cross-account IAM outputs

output "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role"
  value       = aws_iam_role.cross_account_role.arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.cross_account_role.name
}

output "role_id" {
  description = "The unique identifier of the IAM role"
  value       = aws_iam_role.cross_account_role.id
}

output "role_unique_id" {
  description = "The stable and unique string identifying the role"
  value       = aws_iam_role.cross_account_role.unique_id
}

output "assume_role_policy" {
  description = "The assume role policy document"
  value       = aws_iam_role.cross_account_role.assume_role_policy
}

output "instance_profile_arn" {
  description = "The ARN of the instance profile (if created)"
  value       = var.create_instance_profile ? aws_iam_instance_profile.cross_account_profile[0].arn : null
}

output "instance_profile_name" {
  description = "The name of the instance profile (if created)"
  value       = var.create_instance_profile ? aws_iam_instance_profile.cross_account_profile[0].name : null
}

output "trusted_account_ids" {
  description = "List of trusted account IDs that can assume this role"
  value       = var.trusted_account_ids
}

output "attached_policy_arns" {
  description = "List of attached AWS managed policy ARNs"
  value       = var.aws_managed_policy_arns
}

output "custom_policy_name" {
  description = "Name of the custom inline policy (if created)"
  value       = var.custom_policy_document != null ? aws_iam_role_policy.custom_inline[0].name : null
}

output "permissions_boundary_arn" {
  description = "ARN of the permissions boundary policy (if set)"
  value       = var.permissions_boundary_arn
}

output "role_max_session_duration" {
  description = "Maximum session duration for the role"
  value       = aws_iam_role.cross_account_role.max_session_duration
}
