# AWS Organization Management with Terraform

This project manages AWS Organization resources using Terraform for existing organization `o-3hvm9kw45b`.

## 🏗️ Project Structure

```
aws-organization-terraform/
├── environments/
│   └── prod/                    # 🎯 Production environment configuration
│       ├── main.tf             # Main Terraform configuration
│       ├── variables.tf        # Environment variables
│       └── outputs.tf          # Output values
├── modules/                     # 📦 Reusable Terraform modules
│   ├── organizational-unit/    # Creates organizational units
│   ├── member-account/         # Creates member accounts
│   ├── service-control-policy/ # Manages SCPs (future)
│   └── cross-account-iam/      # Cross-account IAM roles (future)
└── README.md                   # This file
```

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform >= 1.5 installed
- Access to existing AWS Organization `o-3hvm9kw45b`

### Deployment

1. **Navigate to production environment:**
   ```bash
   cd environments/prod
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Review the plan:**
   ```bash
   terraform plan
   ```

4. **Apply the configuration:**
   ```bash
   terraform apply
   ```

## 📋 What This Creates

### Organizational Units
- **Development OU** - For development workloads
- **Production OU** - For production workloads  
- **Sandbox OU** - For experimental workloads

### Member Accounts
- **Development Account** (`sirwan.cloud1370+dev@gmail.com`)
- **Production Account** (`sirwan.cloud1370+prod@gmail.com`)
- **Sandbox Account** (`sirwan.cloud1370+sandbox@gmail.com`)

## 🏢 Existing Organization Details
- **Organization ID**: `o-3hvm9kw45b`
- **Management Account**: `235494806851` (Naser Raoofi)
- **Feature Set**: `ALL`

## 🔧 Module Usage

All modules are designed to work with your existing AWS Organization and follow enterprise best practices for:
- Resource tagging
- Lifecycle management
- Security policies
- Cross-account access


