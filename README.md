# Note for FortiAnalyzer Blue Green

This is a guide on how to migrate from FortiAnalyzer to another FortiAnalyzer of the same type or model. To transfer the config to a different HW or VM type, use the exe migrate all-settings CLI command or contact customer support.

## When migrating VM FortiAnalyzer 

1. Two valid VM-licensed instances are needed
2. Use the same VM license within the 7 day grace period before the license becomes invalid)

Regardless of the destination, the destination FortiAnalyzer must have at least the same ADOM quota allocated as the source FortiAnalyzer (the 'diag log device' CLI command can be used for verification).

## FTP, sFTP, scp is a strict requirement to fully back FAZ system settings and log

1. Config backup and restore process.

Go to System Settings -> System Configuration -> Backup.

2. Using the CLI:
This example shows how to back up allFortiAnalyzer unit system settings to a file named faz.cfg on a server at IP address 10.5.50.40 using the ftpuser username and a password of 12345678:

```
exe backup all-settings ftp x.x.x.x /ftpbackup/allsetting/faz.dat ftpuser 12345678
```

# Blue-Green Deployment for FortiAnalyzer in AWS with Terraform

This set of Terraform files facilitates a blue-green deployment strategy for FortiAnalyzer instances in AWS. This approach allows for zero-downtime upgrades by deploying a new instance alongside the existing one before switching traffic over.

## File Structure

```
├── main.tf           # Main Terraform configuration file
├── variables.tf      # Variable declarations
├── outputs.tf        # Output definitions
├── terraform.tfvars  # Variable values (create from terraform.tfvars.example)
└── versions.tf       # Terraform and provider version constraints
```

## Deployment Process

### Step 1: Initial Deployment (Blue Instance)
1. Configure `terraform.tfvars` with a single AMI ID in the blue slot
2. Run `terraform init` and `terraform apply`

### Step 2: Add Green Instance
1. Update `terraform.tfvars` to include both blue and green AMI IDs
2. Run `terraform apply` to add the green instance

### Step 3: Cutover
1. Verify the green instance is functioning correctly
2. Update `terraform.tfvars` to remove the blue AMI ID
3. Run `terraform apply` to remove the blue instance

## Implementation Details

This implementation uses Terraform's `for_each` construct with a map of AMI IDs to create and manage multiple instances.


# How to use the script

How to Use These Files

First, make the helper script executable:
bashchmod +x deploy.sh

Follow the blue-green deployment process:
bash# Initialize Terraform
./deploy.sh --init

## Deploy Blue instance
./deploy.sh --deploy-blue
### Edit terraform.tfvars to set your actual values
terraform apply

## Add Green instance alongside Blue
./deploy.sh --add-green
### Edit terraform.tfvars to set your Green AMI ID
terraform apply

## After verifying Green instance, cut over completely to Green
./deploy.sh --cutover-green
terraform apply

### If you need to rollback:
bash./deploy.sh --rollback
terraform apply

### Check deployment status at any time:
bash./deploy.sh --status
