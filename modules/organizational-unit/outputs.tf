# Organizational Unit Module Outputs

output "id" {
  description = "The organizational unit ID"
  value       = aws_organizations_organizational_unit.this.id
}

output "arn" {
  description = "The organizational unit ARN"
  value       = aws_organizations_organizational_unit.this.arn
}

output "name" {
  description = "The organizational unit name"
  value       = aws_organizations_organizational_unit.this.name
}

output "parent_id" {
  description = "The parent ID of the organizational unit"
  value       = aws_organizations_organizational_unit.this.parent_id
}

output "accounts" {
  description = "List of accounts in this organizational unit"
  value       = aws_organizations_organizational_unit.this.accounts
}

output "organizational_unit" {
  description = "Complete organizational unit object"
  value       = aws_organizations_organizational_unit.this
}
