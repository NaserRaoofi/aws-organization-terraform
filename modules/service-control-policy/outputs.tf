# Service Control Policy Module Outputs
# Enterprise-grade SCP outputs

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

output "policy_description" {
  description = "The description of the Service Control Policy"
  value       = aws_organizations_policy.this.description
}

output "policy_type" {
  description = "The type of the policy (SERVICE_CONTROL_POLICY)"
  value       = aws_organizations_policy.this.type
}

output "attachment_ids" {
  description = "Map of target IDs to their attachment IDs"
  value = {
    for k, v in aws_organizations_policy_attachment.this : k => v.id
  }
}

output "target_ids" {
  description = "List of target IDs where the policy is attached"
  value       = var.target_ids
}

output "policy_document" {
  description = "The policy document content"
  value       = var.policy_document
  sensitive   = true
}
