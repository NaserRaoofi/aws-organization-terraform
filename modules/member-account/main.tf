# Member Account Module

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_organizations_account" "this" {
  name                       = var.name
  email                      = var.email
  parent_id                 = var.parent_id
  role_name                 = var.role_name
  close_on_deletion         = var.close_on_deletion
  create_govcloud           = var.create_govcloud
  iam_user_access_to_billing = var.iam_user_access_to_billing
  
  tags = merge(var.default_tags, var.tags, {
    Name        = var.name
    Email       = var.email
    Type        = "MemberAccount"
    Environment = var.environment
  })

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      # Ignore role_name changes after account creation
      role_name,
    ]
  }
}

# Wait for account creation and role provisioning
resource "time_sleep" "wait_for_account_setup" {
  depends_on = [aws_organizations_account.this]
  
  create_duration = var.account_setup_wait_time
}

# Attach Service Control Policies if provided
resource "aws_organizations_policy_attachment" "scp_attachments" {
  for_each = toset(var.service_control_policy_ids)
  
  policy_id = each.value
  target_id = aws_organizations_account.this.id
  
  depends_on = [time_sleep.wait_for_account_setup]
}
