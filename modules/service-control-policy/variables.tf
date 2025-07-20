# Service Control Policy Module Variables
# Enterprise-grade SCP management variables

variable "name" {
  description = "Name of the Service Control Policy"
  type        = string
  
  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "SCP name must be between 1 and 128 characters."
  }
}

variable "description" {
  description = "Description of the Service Control Policy"
  type        = string
  
  validation {
    condition     = length(var.description) <= 512
    error_message = "SCP description must be 512 characters or less."
  }
}

variable "policy_document" {
  description = "JSON policy document for the SCP"
  type        = string
  
  validation {
    condition     = can(jsondecode(var.policy_document))
    error_message = "Policy document must be valid JSON."
  }
  
  validation {
    condition     = length(var.policy_document) <= 5120
    error_message = "Policy document must be 5120 characters or less."
  }
}

variable "target_ids" {
  description = "List of target IDs (OU IDs or Account IDs) to attach the policy to"
  type        = list(string)
  default     = []
  
  validation {
    condition = alltrue([
      for target in var.target_ids : 
      can(regex("^(r-[0-9a-z]{4,32}|ou-[0-9a-z]{4,32}-[a-z0-9]{8,32}|[0-9]{12})$", target))
    ])
    error_message = "Target IDs must be valid root (r-), organizational unit (ou-), or account (12-digit) identifiers."
  }
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
  description = "Default tags to apply to the SCP"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional tags to apply to the SCP"
  type        = map(string)
  default     = {}
}
