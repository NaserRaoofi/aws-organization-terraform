# Member Account Module Variables
# Copilot is now acting as: AWS Architect (see ../../../organization/config/copilot_role/aws_architect.md)

variable "name" {
  description = "A friendly name for the member account"
  type        = string
  
  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 50
    error_message = "Account name must be between 1 and 50 characters."
  }
}

variable "email" {
  description = "The email address associated with the AWS account"
  type        = string
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email))
    error_message = "Email must be a valid email address."
  }
}

variable "parent_id" {
  description = "Parent Organizational Unit ID or root ID"
  type        = string
  
  validation {
    condition     = can(regex("^(r-[0-9a-z]{4,32}|ou-[0-9a-z]{4,32}-[a-z0-9]{8,32})$", var.parent_id))
    error_message = "Parent ID must be a valid root (r-) or organizational unit (ou-) identifier."
  }
}

variable "environment" {
  description = "Environment name (dev, prod, sandbox, etc.)"
  type        = string
  
  validation {
    condition     = contains(["dev", "prod", "sandbox", "staging", "test"], var.environment)
    error_message = "Environment must be one of: dev, prod, sandbox, staging, test."
  }
}

variable "role_name" {
  description = "The name of an IAM role that Organizations automatically creates"
  type        = string
  default     = "OrganizationAccountAccessRole"
  
  validation {
    condition     = length(var.role_name) >= 1 && length(var.role_name) <= 64
    error_message = "Role name must be between 1 and 64 characters."
  }
}

variable "close_on_deletion" {
  description = "Whether to close the account when removing from organization"
  type        = bool
  default     = false
}

variable "create_govcloud" {
  description = "Whether to create a GovCloud account"
  type        = bool
  default     = false
}

variable "iam_user_access_to_billing" {
  description = "IAM user access to billing information"
  type        = string
  default     = "ALLOW"
  
  validation {
    condition     = contains(["ALLOW", "DENY"], var.iam_user_access_to_billing)
    error_message = "IAM user access to billing must be either 'ALLOW' or 'DENY'."
  }
}

variable "service_control_policy_ids" {
  description = "List of Service Control Policy IDs to attach to this account"
  type        = list(string)
  default     = []
  
  validation {
    condition = alltrue([
      for policy_id in var.service_control_policy_ids : 
      can(regex("^p-[0-9a-z]{8,32}$", policy_id))
    ])
    error_message = "Service Control Policy IDs must be valid policy identifiers starting with 'p-'."
  }
}

variable "account_setup_wait_time" {
  description = "Time to wait for account setup completion"
  type        = string
  default     = "60s"
  
  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.account_setup_wait_time))
    error_message = "Wait time must be in format like '60s', '5m', or '1h'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the account"
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}
