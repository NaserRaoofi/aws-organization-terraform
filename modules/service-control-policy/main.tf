# Service Control Policy Module
# Simple template-based SCP management with IAM role integration

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Load policy template or use custom document
locals {
  policy_content = var.template_name != null ? file("${path.module}/templates/${var.template_name}.json") : var.policy_document
}

# Create Service Control Policy
resource "aws_organizations_policy" "this" {
  name        = var.name
  description = var.description
  type        = "SERVICE_CONTROL_POLICY"
  content     = local.policy_content

  tags = merge(var.default_tags, var.tags, {
    Name        = var.name
    Type        = "ServiceControlPolicy"
    Environment = var.environment
    Template    = var.template_name
  })
}

# Create IAM policy from SCP content for role attachment
resource "aws_iam_policy" "scp_as_iam_policy" {
  name        = "${var.name}-iam-policy"
  description = "IAM policy based on SCP: ${var.description}"
  policy      = local.policy_content

  tags = merge(var.default_tags, var.tags, {
    Name        = "${var.name}-iam-policy"
    Type        = "IAMPolicy"
    Environment = var.environment
    SourceSCP   = var.name
  })
}
