# Cross-Account IAM Module
# Enterprise-grade cross-account IAM role management
# Copilot acting as: AWS Architect

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

# Cross-Account Assumable Role
resource "aws_iam_role" "cross_account_role" {
  name               = var.role_name
  path               = var.role_path
  description        = var.role_description
  max_session_duration = var.max_session_duration

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_account_ids
        }
        Action = "sts:AssumeRole"
        Condition = var.assume_role_conditions
      }
    ]
  })

  tags = merge(var.default_tags, var.tags, {
    Name            = var.role_name
    Type            = "CrossAccountRole"
    Environment     = var.environment
    TrustedAccounts = join(",", var.trusted_account_ids)
  })

  lifecycle {
    prevent_destroy = true
  }
}

# Attach AWS managed policies
resource "aws_iam_role_policy_attachment" "aws_managed" {
  for_each = toset(var.aws_managed_policy_arns)
  
  role       = aws_iam_role.cross_account_role.name
  policy_arn = each.value

  depends_on = [aws_iam_role.cross_account_role]
}

# Create and attach custom inline policy if provided
resource "aws_iam_role_policy" "custom_inline" {
  count = var.custom_policy_document != null ? 1 : 0
  
  name   = "${var.role_name}-custom-policy"
  role   = aws_iam_role.cross_account_role.id
  policy = var.custom_policy_document

  depends_on = [aws_iam_role.cross_account_role]
}

# Permission boundary if specified
resource "aws_iam_role_policy_attachment" "permission_boundary" {
  count = var.permissions_boundary_arn != null ? 1 : 0
  
  role       = aws_iam_role.cross_account_role.name
  policy_arn = var.permissions_boundary_arn

  depends_on = [aws_iam_role.cross_account_role]
}

# Instance profile for EC2 if needed
resource "aws_iam_instance_profile" "cross_account_profile" {
  count = var.create_instance_profile ? 1 : 0
  
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.cross_account_role.name
  path = var.role_path

  tags = merge(var.default_tags, var.tags, {
    Name        = "${var.role_name}-instance-profile"
    Type        = "InstanceProfile"
    Environment = var.environment
  })

  depends_on = [aws_iam_role.cross_account_role]
}

# Local validation
locals {
  # Validate trusted account IDs
  invalid_account_ids = [
    for account_id in var.trusted_account_ids : account_id
    if !can(regex("^[0-9]{12}$", account_id))
  ]
  
  # Check if any invalid account IDs exist
  has_invalid_accounts = length(local.invalid_account_ids) > 0
}
