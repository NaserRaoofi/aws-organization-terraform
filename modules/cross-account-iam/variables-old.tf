# Cross-Account IAM Module Variables
# Simple OU-based role management

variable "organizational_units" {
  description = "Map of organizational units with their configurations"
  type = map(object({
    trusted_accounts = list(string)
    policy_arns      = list(string)
  }))
  default = {}
}

variable "allowed_regions" {
  description = "List of allowed AWS regions for role assumption"
  type        = list(string)
  default     = ["us-east-1", "us-west-2"]
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}
  
  validation {
    condition = alltrue([
      for account_id in var.trusted_account_ids : 
      can(regex("^[0-9]{12}$", account_id))
    ])
    error_message = "All trusted account IDs must be 12-digit AWS account IDs."
  }
  
  validation {
    condition     = length(var.trusted_account_ids) > 0
    error_message = "At least one trusted account ID must be specified."
  }
}

variable "assume_role_conditions" {
  description = "Additional conditions for assume role policy"
  type        = map(any)
  default     = {}
}

variable "aws_managed_policy_arns" {
  description = "List of AWS managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
  
  validation {
    condition = alltrue([
      for arn in var.aws_managed_policy_arns : 
      can(regex("^arn:aws:iam::aws:policy/", arn))
    ])
    error_message = "All policy ARNs must be valid AWS managed policy ARNs."
  }
}

variable "custom_policy_document" {
  description = "JSON policy document for custom inline policy (optional)"
  type        = string
  default     = null
  
  validation {
    condition = var.custom_policy_document == null || can(jsondecode(var.custom_policy_document))
    error_message = "Custom policy document must be valid JSON if provided."
  }
}

variable "permissions_boundary_arn" {
  description = "ARN of the permissions boundary policy"
  type        = string
  default     = null
  
  validation {
    condition = var.permissions_boundary_arn == null || can(regex("^arn:aws:iam::", var.permissions_boundary_arn))
    error_message = "Permissions boundary ARN must be a valid IAM policy ARN if provided."
  }
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile for EC2 use"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "production"
  
  validation {
    condition     = contains(["dev", "staging", "prod", "production", "sandbox"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod, production, sandbox."
  }
}

variable "default_tags" {
  description = "Default tags to apply to IAM resources"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional tags to apply to IAM resources"
  type        = map(string)
  default     = {}
}
