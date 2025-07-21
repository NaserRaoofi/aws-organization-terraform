# Service Control Policy Module Variables
# Simple template-based SCP management

variable "name" {
  description = "Name of the Service Control Policy"
  type        = string
}

variable "description" {
  description = "Description of the Service Control Policy"
  type        = string
  default     = "Service Control Policy"
}

variable "template_name" {
  description = "Name of the policy template to use (without .json extension)"
  type        = string
  default     = null
}

variable "policy_document" {
  description = "Custom policy document JSON (used if template_name is null)"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "dev"
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "target_ou_id" {
  description = "Organizational Unit ID to attach the SCP to (optional)"
  type        = string
  default     = null
}

variable "create_iam_policy" {
  description = "Whether to create an IAM policy version of the SCP"
  type        = bool
  default     = false
}
