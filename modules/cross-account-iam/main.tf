# Cross-Account IAM Module with OU-based Roles
# Simple role management for organizational units

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Data source for current AWS account
data "aws_caller_identity" "current" {}

# Data source for organization
data "aws_organizations_organization" "current" {}

# Create roles for each organizational unit
resource "aws_iam_role" "ou_roles" {
  for_each = var.organizational_units

  name        = "${each.key}-ou-role"
  description = "Role for ${each.key} organizational unit"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = each.value.trusted_accounts
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = var.allowed_regions
          }
        }
      }
    ]
  })

  tags = merge(var.default_tags, {
    Name            = "${each.key}-ou-role"
    OrganizationalUnit = each.key
    Environment     = var.environment
    Type           = "OURole"
  })
}

# Attach policies to OU roles
resource "aws_iam_role_policy_attachment" "ou_policies" {
  for_each = {
    for combo in local.role_policy_combinations : "${combo.role}-${combo.policy}" => combo
  }

  role       = aws_iam_role.ou_roles[each.value.role].name
  policy_arn = each.value.policy_arn
}

# Local combinations for role-policy attachments
locals {
  role_policy_combinations = flatten([
    for ou_name, ou_config in var.organizational_units : [
      for policy_arn in ou_config.policy_arns : {
        role       = ou_name
        policy_arn = policy_arn
      }
    ]
  ])
}

# Create IAM roles delegation configuration for OUs
# This creates a mapping between roles and their target OUs
resource "aws_ssm_parameter" "ou_role_mapping" {
  for_each = var.organizational_units

  name  = "/organization/ou-roles/${each.key}/role-arn"
  type  = "String"
  value = aws_iam_role.ou_roles[each.key].arn
  description = "Role ARN for ${each.key} organizational unit (${each.value.ou_id})"

  tags = merge(var.default_tags, {
    Name               = "${each.key}-ou-role-mapping"
    OrganizationalUnit = each.key
    OrganizationalUnitId = each.value.ou_id
    RoleName          = aws_iam_role.ou_roles[each.key].name
    Environment       = var.environment
    Type              = "OURoleMapping"
  })
}
