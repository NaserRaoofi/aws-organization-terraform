# Organizational Unit Module Variables
# Copilot is now acting as: AWS Architect (see ../../../organization/config/copilot_role/aws_architect.md)

variable "name" {
  description = "The name of the organizational unit"
  type        = string
  
  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "Organizational unit name must be between 1 and 128 characters."
  }
}

variable "parent_id" {
  description = "The parent ID (root or another OU) where this OU will be created"
  type        = string
  
  validation {
    condition     = can(regex("^(r-[0-9a-z]{4,32}|ou-[0-9a-z]{4,32}-[a-z0-9]{8,32})$", var.parent_id))
    error_message = "Parent ID must be a valid root (r-) or organizational unit (ou-) identifier."
  }
}

variable "service_control_policy_ids" {
  description = "List of Service Control Policy IDs to attach to this OU"
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

variable "tags" {
  description = "A map of tags to assign to the organizational unit"
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}
