# Cross-Account IAM Module Outputs
# Simple OU-based role outputs

output "ou_role_arns" {
  description = "Map of organizational unit names to their role ARNs"
  value = {
    for ou_name, role in aws_iam_role.ou_roles : ou_name => role.arn
  }
}

output "ou_role_names" {
  description = "Map of organizational unit names to their role names"
  value = {
    for ou_name, role in aws_iam_role.ou_roles : ou_name => role.name
  }
}

output "role_summary" {
  description = "Summary of all created roles with OU assignments"
  value = {
    for ou_name, role in aws_iam_role.ou_roles : ou_name => {
      role_name = role.name
      role_arn  = role.arn
      role_id   = role.id
      ou_id     = var.organizational_units[ou_name].ou_id
      mapping_parameter = aws_ssm_parameter.ou_role_mapping[ou_name].name
    }
  }
}

output "ou_role_mappings" {
  description = "Map of OU names to their role and OU ID assignments"
  value = {
    for ou_name, ou_config in var.organizational_units : ou_name => {
      ou_id    = ou_config.ou_id
      role_arn = aws_iam_role.ou_roles[ou_name].arn
      role_name = aws_iam_role.ou_roles[ou_name].name
    }
  }
}
