# Production Environment Variables
# Managing existing AWS Organization: o-3hvm9kw45b

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "AWS region must be a valid region format (e.g., us-east-1)."
  }
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default = {
    Project           = "AWS-Organization-Management"
    ManagedBy        = "Terraform"
    Organization     = "o-3hvm9kw45b"
    ManagementAccount = "235494806851"
    Environment      = "Production"
  }
}
