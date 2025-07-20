# Service Control Policy Module
# Enterprise-grade SCP management for AWS Organizations
# Copilot acting as: AWS Architect

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Create Service Control Policy
resource "aws_organizations_policy" "this" {
  name        = var.name
  description = var.description
  type        = "SERVICE_CONTROL_POLICY"
  content     = var.policy_document

  tags = merge(var.default_tags, var.tags, {
    Name        = var.name
    Type        = "ServiceControlPolicy"
    Environment = var.environment
  })

  lifecycle {
    prevent_destroy = true
  }
}

# Attach SCP to targets (OUs or accounts)
resource "aws_organizations_policy_attachment" "this" {
  for_each = toset(var.target_ids)
  
  policy_id = aws_organizations_policy.this.id
  target_id = each.value

  depends_on = [aws_organizations_policy.this]
}

# Data source to validate targets
data "aws_organizations_organization" "current" {}

# Local validation
locals {
  # Validate that all target IDs are valid OU or account IDs
  valid_target_pattern = "^(r-[0-9a-z]{4,32}|ou-[0-9a-z]{4,32}-[a-z0-9]{8,32}|[0-9]{12})$"
  
  invalid_targets = [
    for target in var.target_ids : target
    if !can(regex(local.valid_target_pattern, target))
  ]
}
