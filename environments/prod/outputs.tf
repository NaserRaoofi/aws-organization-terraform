# Production Environment Outputs

# Organization Information
output "organization_id" {
  description = "The ID of the existing AWS Organization"
  value       = data.aws_organizations_organization.existing.id
}

output "organization_root_id" {
  description = "The root ID of the existing AWS Organization"
  value       = data.aws_organizations_organization.existing.roots[0].id
}

# Organizational Units
output "organizational_units" {
  description = "Map of organizational unit names to their IDs"
  value = {
    for k, v in module.organizational_units : k => v.id
  }
}

# Member Accounts
output "member_accounts" {
  description = "Map of member account names to their details"
  value = {
    for k, v in module.member_accounts : k => {
      id    = v.id
      email = v.email
      name  = v.name
    }
  }
}
