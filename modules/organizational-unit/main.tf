# Organizational Unit Module

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_organizations_organizational_unit" "this" {
  name      = var.name
  parent_id = var.parent_id
  
  tags = merge(var.default_tags, var.tags, {
    Name = var.name
    Type = "OrganizationalUnit"
  })
}

# Attach Service Control Policies if provided
resource "aws_organizations_policy_attachment" "scp_attachments" {
  for_each = toset(var.service_control_policy_ids)
  
  policy_id = each.value
  target_id = aws_organizations_organizational_unit.this.id
}
