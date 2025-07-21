# Service Control Policy Module Outputs

output "policy_id" {
  description = "The unique identifier of the Service Control Policy"
  value       = aws_organizations_policy.this.id
}

output "policy_arn" {
  description = "The Amazon Resource Name (ARN) of the Service Control Policy"
  value       = aws_organizations_policy.this.arn
}

output "policy_name" {
  description = "The name of the Service Control Policy"
  value       = aws_organizations_policy.this.name
}

output "template_name" {
  description = "Name of the template used (if template-based deployment)"
  value       = var.template_name
}

output "iam_policy_arn" {
  description = "ARN of the IAM policy version"
  value       = aws_iam_policy.scp_as_iam_policy.arn
}

output "iam_policy_name" {
  description = "Name of the IAM policy version"
  value       = aws_iam_policy.scp_as_iam_policy.name
}
