# Cross-Account IAM Module Variables
# Simple OU-based role management

variable "organizational_units" {
  description = "Map of organizational units with their configurations"
  type = map(object({
    ou_id            = string
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
