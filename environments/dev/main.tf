# Development Environment - AWS Organization Management
# Managing existing AWS Organization: o-3hvm9kw45b

terraform {
  required_version = ">= 1.5"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }

  # Remote state configuration (recommended for production)
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "organization/dev/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

# Configure AWS Provider
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = var.default_tags
  }
}

# Data source to reference existing organization
data "aws_organizations_organization" "existing" {}

# Local values for organization configuration
locals {
  # Organizational Units configuration
  organizational_units = {
    development = {
      name = "Development"
      service_control_policy_ids = []
    }
    staging = {
      name = "Staging"
      service_control_policy_ids = []
    }
    sandbox = {
      name = "Sandbox"
      service_control_policy_ids = []
    }
  }
  
  # Member accounts configuration
  member_accounts = {
    dev = {
      name        = "Development Account"
      email       = "sirwan.cloud1370+dev@gmail.com"
      environment = "dev"
      ou_key      = "development"
    }
    staging = {
      name        = "Staging Account"
      email       = "sirwan.cloud1370+staging@gmail.com" 
      environment = "staging"
      ou_key      = "staging"
    }
    sandbox = {
      name        = "Sandbox Account"
      email       = "sirwan.cloud1370+sandbox@gmail.com"
      environment = "sandbox"
      ou_key      = "sandbox"
    }
  }
}

# Data sources for existing organizational units
data "aws_organizations_organizational_units" "existing_ous" {
  parent_id = data.aws_organizations_organization.existing.roots[0].id
}

# Reference existing organizational units by name
locals {
  existing_ous = {
    for ou in data.aws_organizations_organizational_units.existing_ous.children :
    lower(ou.name) => ou.id
  }
}

# COMMENTED OUT - Use existing OUs instead of creating new ones
# Create Organizational Units
# module "organizational_units" {
#   source = "../../modules/organizational-unit"
#   
#   for_each = local.organizational_units
#   
#   name                       = each.value.name
#   parent_id                 = data.aws_organizations_organization.existing.roots[0].id
#   service_control_policy_ids = each.value.service_control_policy_ids
#   
#   default_tags = var.default_tags
#   tags = {
#     Environment = each.key
#     Purpose     = "Organizational unit for ${each.value.name} workloads"
#   }
# }

# COMMENTED OUT - Use existing accounts instead of creating new ones
# Create Member Accounts
# module "member_accounts" {
#   source = "../../modules/member-account"
#   
#   for_each = local.member_accounts
#   
#   name         = each.value.name
#   email        = each.value.email
#   environment  = each.value.environment
#   parent_id    = module.organizational_units[each.value.ou_key].id
#   
#   # Account settings
#   role_name                  = "OrganizationAccountAccessRole"
#   close_on_deletion         = false
#   create_govcloud           = false
#   iam_user_access_to_billing = "ALLOW"
#   account_setup_wait_time   = "90s"
#   
#   default_tags = var.default_tags
#   tags = {
#     Environment = each.value.environment
#     Purpose     = "${each.value.name} for ${each.value.environment} workloads"
#     Owner       = "platform-team"
#   }
#   
#   depends_on = [module.organizational_units]
# }

# Service Control Policies with Direct OU Attachment
module "scp_policies" {
  source = "../../modules/service-control-policy"
  
  for_each = {
    development = {
      template_name = "development-scp"
      ou_id        = local.existing_ous["development"]
    }
    production = {
      template_name = "production-scp"
      ou_id        = local.existing_ous["production"]
    }
    sandbox = {
      template_name = "sandbox-scp"
      ou_id        = local.existing_ous["sandbox"]
    }
  }

  # Core Configuration
  name           = "${each.key}-ou-security-policy"
  template_name  = each.value.template_name
  target_ou_id   = each.value.ou_id
  environment    = each.key
  
  # No need for IAM policy creation with direct OU attachment
  create_iam_policy = false
  
  # Enhanced Tagging
  default_tags = merge(var.default_tags, {
    PolicyType   = "ServiceControlPolicy"
    TargetType   = "OrganizationalUnit"
    ReviewCycle  = "Monthly"
  })
  
  tags = {
    OU             = each.key
    Template       = each.value.template_name
    DeploymentDate = "2025-07-21"
    LastReview     = "2025-07-21"
    AttachedToOU   = each.value.ou_id
  }
}


