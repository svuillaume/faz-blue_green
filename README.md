# Note for FortiAnalyzer Blue Green

This is a guide on how to migrate from FortiAnalyzer to another FortiAnalyzer of the same type or model. To transfer the config to a different HW or VM type, use the exe migrate all-settings CLI command or contact customer support.

## When migrating VM FortiAnalyzer 

1. Two valid VM-licensed instances are needed
2. Use the same VM license within the 7 day grace period before the license becomes invalid)

Regardless of the destination, the destination FortiAnalyzer must have at least the same ADOM quota allocated as the source FortiAnalyzer (the 'diag log device' CLI command can be used for verification).

## Backing up configuration files and databases

Back up the FortiAnalyzer configuration file and databases.

It is recommended that you create a system backup file and save this configuration to your local computer. The device configuration file is saved with a .dat extension.
It is also recommended that you verify the integrity of your backup file.

### Note 

When the database is larger than 2.8 GB, back up the configuration file to an FTP, SFTP, or SCP server using the following CLI command:
execute backup all-settings {ftp | sftp} <ip> <path/filename of server> <username on server> <password> <crptpasswd>
execute backup all-settings scp <ip> <path/filename of server> <SSH certificate> <crptpasswd>

### Further details at:

1. https://docs.fortinet.com/document/fortianalyzer/7.6.2/upgrade-guide/621448/backing-up-configuration-files-and-databases
2. https://community.fortinet.com/t5/FortiAnalyzer/Technical-Tip-Backup-and-restore-of-FortiAnalyzer-settings-logs/ta-p/191972

## FTP, sFTP, scp is a strict requirement to fully back FAZ system settings and log

1. Config backup and restore process.

Go to System Settings -> System Configuration -> Backup.

2. Using the CLI:

## Backup Procedure (using ftp, scp/sftp is however recommended in Public CLoud)

```
exe backup all-settings ftp x.x.x.x /ftpbackup/allsetting/faz.dat ftpuser 12345678
```

or using Web UI

## Restore Procedure

Use execute backup all-settings to preserve full setup (devices, ADOMs, reports).

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

Use execute log backup for log archives only.

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
chmod +x bg.sh
```

3. Follow the blue-green deployment process, terraform init:

```
./bg.sh --init

```
## Deploy Blue instance

```
./bg.sh --deploy-blue
```

Edit terraform.tfvars to set your actual values

```
terraform apply
```

## Add Green instance alongside Blue

```
./bg.sh --add-green
```

Edit terraform.tfvars to set your Green AMI ID

```
terraform apply
```
## After verifying Green instance, cut over completely to Green

```
./bg.sh --cutover-green
terraform apply
```

### If you need to rollback:

```
./bg.sh --rollback
terraform apply
```

### Check deployment status at any time:

```
./bg.sh --status
```
