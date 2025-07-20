# Cross-Account IAM Module
# This module will manage cross-account IAM roles and policies
# Currently under development

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# TODO: Implement cross-account IAM role resources
# This module is reserved for future implementation of:
# - Cross-account assumable roles
# - Trust relationships between accounts
# - Permission boundaries for cross-account access
