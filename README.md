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

## Backup Procedure

```
exe backup all-settings ftp x.x.x.x /ftpbackup/allsetting/faz.dat ftpuser 12345678
```

or using Web UI

## Restore Procedure

To restore this backup on a new FAZ instance (with same FortiAnalyzer version!):

```
execute restore all-settings ftp x.x.x.x /ftpbackup/allsetting/faz.dat ftpuser 12345678
```
or using Web UI

### Note Backup and Restore

Uncheck the Overwite current IP and routing settings option to avoid any duplicate IP conflict with the old system.
Once the new FortiAnalyzer is ready to receive the logs from the FortiGate, all the senders need to be configured so that the new IP address is used to receive logs.
To do this, use the following CLI command:

```
config log fortianalyzer_new 
```

### Log Backup only 

```
exe backup logs all ftp x.x.x.x ftpuser 12345678 /
```

### FAZ Fetching Logs (when using 2 FAZ instances) 

https://docs.fortinet.com/document/fortianalyzer/6.2.0/cookbook/366512/fetching-logs-from-one-fortianalyzer-to-another

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

1. First, make the helper script executable:

```
chmod +x deploy.sh
```

3. Follow the blue-green deployment process, terraform init:

```
./deploy.sh --init

```
## Deploy Blue instance

```
./deploy.sh --deploy-blue
```

Edit terraform.tfvars to set your actual values

```
terraform apply
```

## Add Green instance alongside Blue

```
./deploy.sh --add-green
```

Edit terraform.tfvars to set your Green AMI ID

```
terraform apply
```
## After verifying Green instance, cut over completely to Green

```
./deploy.sh --cutover-green
terraform apply
```

### If you need to rollback:

```
./deploy.sh --rollback
terraform apply
```

### Check deployment status at any time:

```
./deploy.sh --status
```
