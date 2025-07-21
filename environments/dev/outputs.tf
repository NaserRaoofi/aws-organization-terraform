# Development Environment Outputs

# Organization Information
output "organization_id" {
  description = "The ID of the existing AWS Organization"
  value       = data.aws_organizations_organization.existing.id
}

output "organization_root_id" {
  description = "The root ID of the existing AWS Organization"
  value       = data.aws_organizations_organization.existing.roots[0].id
}

# Organizational Units (Existing)
output "organizational_units" {
  description = "Map of existing organizational unit names to their IDs"
  value       = local.existing_ous
}

# Member Accounts (Existing - commented out as module is disabled)
# output "member_accounts" {
#   description = "Map of member account names to their details"
#   value = {
#     for k, v in module.member_accounts : k => {
#       id    = v.id
#       email = v.email
#       name  = v.name
#     }
#   }
# }

# Service Control Policies
output "scp_policies" {
  description = "Service Control Policy information with OU attachments"
  value = {
    for k, v in module.scp_policies : k => {
      policy_id       = v.policy_id
      policy_arn      = v.policy_arn
      policy_name     = v.policy_name
      template_used   = v.template_name
      attachment_id   = v.attachment_id
      attached_to_ou  = local.existing_ous[k]
    }
  }
}

output "scp_deployment_summary" {
  description = "Complete SCP deployment summary for operations"
  value = {
    total_policies     = length(module.scp_policies)
    deployment_date    = "2025-07-21"
    environments       = keys(module.scp_policies)
    management_contact = "dev-team@sirwan.cloud"
    attachment_method  = "Direct OU Attachment"
  }
}
