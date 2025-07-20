# Member Account Module Outputs
# Copilot is now acting as: AWS Architect (see ../../../organization/config/copilot_role/aws_architect.md)

output "id" {
  description = "The AWS account ID"
  value       = aws_organizations_account.this.id
}

output "arn" {
  description = "The AWS account ARN"
  value       = aws_organizations_account.this.arn
}

output "name" {
  description = "The account name"
  value       = aws_organizations_account.this.name
}

output "email" {
  description = "The account email"
  value       = aws_organizations_account.this.email
  sensitive   = true
}

output "status" {
  description = "The account status"
  value       = aws_organizations_account.this.status
}

output "joined_method" {
  description = "The method by which the account joined the organization"
  value       = aws_organizations_account.this.joined_method
}

output "joined_timestamp" {
  description = "The date the account was created or joined the organization"
  value       = aws_organizations_account.this.joined_timestamp
}

output "parent_id" {
  description = "The parent organizational unit ID"
  value       = aws_organizations_account.this.parent_id
}

output "govcloud_id" {
  description = "The GovCloud account ID (if created)"
  value       = aws_organizations_account.this.govcloud_id
}

output "account" {
  description = "Complete account object"
  value       = aws_organizations_account.this
  sensitive   = true
}

output "cross_account_role_arn" {
  description = "ARN of the cross-account access role"
  value       = "arn:aws:iam::${aws_organizations_account.this.id}:role/${var.role_name}"
}
