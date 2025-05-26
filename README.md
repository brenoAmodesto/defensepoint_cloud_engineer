# DefensePoint Cloud Engineer Assessment

## Overview

This project provisions a secure AWS environment for Wazuh using Terraform, following best practices for modularity, security, and maintainability.

---

## Directory Structure

```
assessment/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── [modules: vpc, ec2, iam, security_groups]
├── scripts/
│   └── install_wazuh.sh
├── docker/
│   └── docker-compose.yml
└── README.md
```

---

## 1. **Terraform Infrastructure**

- **Modularized**: VPC, Security Group, IAM, and EC2 are separate modules for reusability and clarity.
- **Security**: 
  - Private subnets for EC2.
  - Security Group allows only outbound traffic (no SSH/RDP).
  - Access to EC2 is only via AWS SSM Session Manager.
- **Tagging**: All resources are tagged with environment and name.
- **Cost Optimization**: Only necessary resources are provisioned; NAT Gateway is single-AZ for dev.
- **Logging**: rsyslog enabled on EC2 for basic system logging.

**Decision Rationale**:  
We chose to split infrastructure into modules (`vpc`, `security_group`, `iam`, `ec2`) to ensure reusability, clarity, and easier maintenance. Each module is called from the main `main.tf`, passing outputs as inputs to dependent modules.

---

## 2. **Installation Script**

- Located at `scripts/install_wazuh.sh`
- Installs Docker, Docker Compose, rsyslog, and deploys Wazuh using the provided Docker Compose file.
- Handles errors with `set -e` and checks for command success.

---

## 3. **Docker Compose File**

- Located at `docker/docker-compose.yml`
- Uses official Wazuh image.
- Volumes for data persistence.
- Healthcheck included.
- Only necessary ports exposed.

---

## 4. **Setup Instructions**

### Prerequisites

- AWS CLI configured
- Terraform >= 1.0
- IAM user with sufficient permissions

### Steps

1. **Clone the repository**
2. **Initialize Terraform**
   ```sh
   cd assessment/terraform
   terraform init
   ```
3. **Review and apply the plan**
   ```sh
   terraform plan
   terraform apply
   ```
4. **Access**
   - EC2 is in a private subnet, accessible only via AWS SSM Session Manager.
   - Wazuh UI: Exposed only if you open the port in the Security Group (not recommended for production).

---

## 5. **Testing**

- Use AWS Systems Manager > Session Manager to connect to the EC2 instance.
- Run `docker ps` to verify Wazuh is running.
- Check logs: `docker logs wazuh` and `/var/log/messages` for system logs.

---

## 6. **Security Best Practices**

- No public SSH/RDP access.
- All resources are tagged.
- Minimal IAM permissions.
- Logging enabled.
- Use of private subnets for sensitive workloads.

---

## 7. **Assumptions**

- The AMI used is Amazon Linux 2.
- Only one NAT Gateway for cost optimization in dev.
- Wazuh is deployed in single-node mode for simplicity.

---

## 8. **Cleanup**

After testing, destroy all resources to avoid unnecessary AWS charges:

```sh
terraform destroy
```

---

## 9. **Notes**

- All scripts include basic error handling.
- Docker Compose waits for dependencies via healthcheck.
- Followed AWS Well-Architected Framework guidelines where possible.

---

## Diagram

```
+----------------------------- AWS Account ------------------------------+
|                                                                       |
|  +-------------------+           +-------------------+                |
|  |   Public Subnet   |           |   Public Subnet   |                |
|  |   (us-east-1a)    |           |   (us-east-1b)    |                |
|  |                   |           |                   |                |
|  |  IGW <--------->  |           |                   |                |
|  +--------+----------+           +----------+--------+                |
|           |                                 |                         |
|           |                                 |                         |
|  +--------v----------+           +----------v--------+                |
|  |  Private Subnet   |           |  Private Subnet   |                |
|  |   (us-east-1a)    |           |   (us-east-1b)    |                |
|  |                   |           |                   |                |
|  |  [EC2: Wazuh]     |           |                   |                |
|  |  (Docker, SSM)    |           |                   |                |
|  +--------+----------+           +----------+--------+                |
|           |                                 |                         |
|           +-------------+   +---------------+                         |
|                         |   |                                         |
|                     +---v---v---+                                     |
|                     |  NAT GW   |                                     |
|                     +-----------+                                     fix |
|                                                                       |
|  [Security Group: Only outbound allowed, no SSH/RDP]                  |
|  [IAM Role: SSM Managed Instance Core]                                |
|                                                                       |
+-----------------------------------------------------------------------+
```