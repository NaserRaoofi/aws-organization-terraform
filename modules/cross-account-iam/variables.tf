# Cross-Account IAM Module Variables
# Enterprise-grade cross-account IAM role management variables

variable "role_name" {
  description = "Name of the cross-account IAM role"
  type        = string
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "Role name must be 1-64 characters and contain only valid IAM role name characters."
  }
}

variable "role_path" {
  description = "Path for the IAM role"
  type        = string
  default     = "/"
  
  validation {
    condition     = can(regex("^/.*/$", var.role_path)) || var.role_path == "/"
    error_message = "Role path must start and end with forward slash."
  }
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = "Cross-account assumable role"
  
  validation {
    condition     = length(var.role_description) <= 1000
    error_message = "Role description must be 1000 characters or less."
  }
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds (1 hour to 12 hours)"
  type        = number
  default     = 3600
  
  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Max session duration must be between 3600 (1 hour) and 43200 (12 hours) seconds."
  }
}

variable "trusted_account_ids" {
  description = "List of AWS account IDs that can assume this role"
  type        = list(string)
  
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
