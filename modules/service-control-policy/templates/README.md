# Service Control Policy Templates

## 📋 Overview
This directory contains production-ready Service Control Policy (SCP) templates designed for enterprise AWS Organizations. Each template follows the principle of least privilege and implements defense-in-depth security controls.

## 🛡️ Policy Templates

### 1. Development SCP (`development-scp.json`)
**Purpose**: Secure development environment with controlled resource usage

**Key Controls**:
- ✅ Restricts EC2 instances to cost-effective types (t2/t3 nano-small)
- ✅ Prevents expensive service usage (RedShift, large RDS instances)
- ✅ Blocks billing/cost management access
- ✅ Prevents organization structure changes
- ✅ Enforces regional restrictions (us-east-1, us-west-2, eu-west-1)
- ✅ Protects production-tagged resources from deletion
- ✅ Denies root account usage

**Use Case**: Development accounts where cost control and experimentation safety are priorities

### 2. Sandbox SCP (`sandbox-scp.json`)
**Purpose**: Experimental environment with balanced freedom and protection

**Key Controls**:
- ✅ Allows broader EC2 instance types (up to t3.medium)
- ✅ Blocks billing/cost management access
- ✅ Prevents organization changes
- ✅ Protects non-temporary data from deletion
- ✅ Allows experimentation with sandbox-tagged resources

**Use Case**: Innovation and testing environments where developers need flexibility

### 3. Production SCP (`production-scp.json`)
**Purpose**: High-security production environment with strict controls

**Key Controls**:
- ✅ Requires MFA for destructive operations
- ✅ Enforces SSL/TLS for all S3 operations
- ✅ Restricts high-risk IAM actions
- ✅ Blocks billing access (except for specific services)
- ✅ Prevents organization structure modifications
- ✅ Implements additional security guardrails

**Use Case**: Production workloads requiring maximum security and compliance

## 🔧 Usage Guidelines

### Policy Selection Matrix
| Environment | Template | Risk Level | Cost Control | Flexibility |
|-------------|----------|------------|--------------|-------------|
| Development | `development-scp.json` | Low | High | Medium |
| Sandbox | `sandbox-scp.json` | Medium | Medium | High |
| Production | `production-scp.json` | High | Low | Low |

### Implementation Best Practices

1. **Gradual Rollout**: Start with development, validate, then promote
2. **Testing**: Always test SCPs in a non-production environment first
3. **Monitoring**: Set up CloudTrail logging to monitor denied actions
4. **Documentation**: Maintain change logs for policy modifications
5. **Emergency Access**: Ensure break-glass procedures are documented

### Customization Points

```json
// Regional restrictions - modify as needed
"aws:RequestedRegion": [
  "us-east-1",    // Primary region
  "us-west-2",    // DR region
  "eu-west-1"     // Additional region
]

// Instance type restrictions - adjust for workload needs
"ec2:InstanceType": [
  "t3.nano",      // Cost-effective
  "t3.micro",     // Basic workloads
  "t3.small"      // Development needs
]

// Environment tagging - align with your tagging strategy
"aws:RequestTag/Environment": "production"
```

## ⚠️ Important Considerations

### Before Implementation
- [ ] Review current AWS usage patterns
- [ ] Identify critical applications and dependencies
- [ ] Document emergency access procedures
- [ ] Test policies in development environment
- [ ] Train teams on new restrictions

### Monitoring and Compliance
- [ ] Enable CloudTrail in all accounts
- [ ] Set up CloudWatch alarms for denied actions
- [ ] Regular policy review and updates
- [ ] Compliance reporting and audit trails

### Emergency Procedures
If an SCP blocks critical operations:
1. Document the business justification
2. Follow change management process
3. Temporarily modify policy if approved
4. Implement permanent fix through code review
5. Update documentation and training

## 🔄 Maintenance

### Regular Reviews
- **Monthly**: Review denied actions in CloudTrail
- **Quarterly**: Assess policy effectiveness and business alignment
- **Annually**: Comprehensive security and compliance review

### Version Control
All policy changes must:
- Go through code review process
- Include testing in development environment
- Have rollback plan documented
- Update this documentation

---

**Security Contact**: platform-team@company.com  
**Last Updated**: $(date +'%Y-%m-%d')  
**Version**: 1.0.0
