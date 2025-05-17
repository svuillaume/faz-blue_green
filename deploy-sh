#!/bin/bash
# deploy.sh - Helper script for managing blue-green FortiAnalyzer deployments

# Set script to exit immediately if a command exits with a non-zero status
set -e

# Constants
TFVARS_FILE="terraform.tfvars"
BACKUP_FILE="terraform.tfvars.backup"

# Functions
show_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  --init             Initialize Terraform"
  echo "  --deploy-blue      Deploy initial Blue instance"
  echo "  --add-green        Add Green instance alongside Blue"
  echo "  --cutover-green    Remove Blue and keep only Green"
  echo "  --rollback         Rollback to Blue instance"
  echo "  --status           Show current deployment status"
  echo "  --help             Show this help message"
  exit 0
}

backup_tfvars() {
  if [ -f "$TFVARS_FILE" ]; then
    cp "$TFVARS_FILE" "$BACKUP_FILE"
    echo "Backed up $TFVARS_FILE to $BACKUP_FILE"
  fi
}

terraform_init() {
  echo "🚀 Initializing Terraform..."
  terraform init
}

deploy_blue() {
  echo "Preparing Blue deployment"
  
  # Backup existing tfvars if exists
  backup_tfvars
  
  # Create terraform.tfvars with Blue configuration
  cat > "$TFVARS_FILE" << EOF
# AWS region
aws_region = "us-east-1"

# Environment tag
environment = "prod"

# FortiAnalyzer AMI IDs - Blue Only
faz_ami_ids = {
  blue = "ami-0abcdef1234567890"  # Replace with your Blue AMI ID
}

# Network configuration
subnet_id = "subnet-0abcdef1234567890"
security_group_ids = ["sg-0abcdef1234567890"]

# SSH key
key_name = "your-ssh-key-name"

# Instance type
instance_type = "m5.large"

# Volume configuration
root_volume_size = 50
data_volume_size = 100
EOF

  echo "Created $TFVARS_FILE with Blue configuration"
  echo "IMPORTANT: Edit $TFVARS_FILE to set your actual values before applying!"
  echo ""
  echo "Then run: terraform apply"
}

add_green() {
  echo "Preparing Green instance addition..."
  
  # Backup existing tfvars
  backup_tfvars
  
  # Read current AMI ID
  BLUE_AMI=$(grep "blue =" "$TFVARS_FILE" | sed 's/.*"\(.*\)".*/\1/')
  
  # Create terraform.tfvars with Blue and Green configuration
  cat > "$TFVARS_FILE" << EOF
# AWS region
aws_region = "us-east-1"

# Environment tag
environment = "prod"

# FortiAnalyzer AMI IDs - Blue and Green
faz_ami_ids = {
  blue = "$BLUE_AMI"  # Existing Blue AMI
  green = "ami-0fedcba0987654321"  # Replace with your Green AMI ID
}

# Network configuration
subnet_id = "subnet-0abcdef1234567890"
security_group_ids = ["sg-0abcdef1234567890"]

# SSH key
key_name = "your-ssh-key-name"

# Instance type
instance_type = "m5.large"

# Volume configuration
root_volume_size = 50
data_volume_size = 100
EOF

  echo "Updated $TFVARS_FILE with Blue and Green configuration"
  echo "IMPORTANT: Edit $TFVARS_FILE to set your actual Green AMI ID before applying!"
  echo ""
  echo "Then run: terraform apply"
}

cutover_green() {
  echo "Preparing cutover to Green instance..."
  
  # Backup existing tfvars
  backup_tfvars
  
  # Read current Green AMI ID
  GREEN_AMI=$(grep "green =" "$TFVARS_FILE" | sed 's/.*"\(.*\)".*/\1/')
  
  # Create terraform.tfvars with Green configuration only
  cat > "$TFVARS_FILE" << EOF
# AWS region
aws_region = "us-east-1"

# Environment tag
environment = "prod"

# FortiAnalyzer AMI IDs - Green Only
faz_ami_ids = {
  green = "$GREEN_AMI"  # Green AMI only
}

# Network configuration
subnet_id = "subnet-0abcdef1234567890"
security_group_ids = ["sg-0abcdef1234567890"]

# SSH key
key_name = "your-ssh-key-name"

# Instance type
instance_type = "m5.large"

# Volume configuration
root_volume_size = 50
data_volume_size = 100
EOF

  echo "Updated $TFVARS_FILE with Green-only configuration"
  echo ""
  echo "Run: terraform apply"
  echo "This will destroy the Blue instance!"
}

rollback() {
  echo "Rolling back to Blue instance..."
  
  if [ -f "$BACKUP_FILE" ]; then
    cp "$BACKUP_FILE" "$TFVARS_FILE"
    echo "Restored $TFVARS_FILE from backup"
    echo ""
    echo "Run: terraform apply"
  else
    echo "No backup file found at $BACKUP_FILE"
    exit 1
  fi
}

show_status() {
  echo "Current deployment status:"
  echo ""
  
  if [ -f "$TFVARS_FILE" ]; then
    if grep -q "blue =" "$TFVARS_FILE" && grep -q "green =" "$TFVARS_FILE"; then
      echo "BLUE-GREEN: Both Blue and Green instances are configured"
    elif grep -q "blue =" "$TFVARS_FILE"; then
      echo "BLUE ONLY: Only Blue instance is configured"
    elif grep -q "green =" "$TFVARS_FILE"; then
      echo "GREEN ONLY: Only Green instance is configured"
    else
      echo "UNKNOWN: No instances are configured in $TFVARS_FILE"
    fi
    
    echo ""
    echo "AMI IDs configured:"
    grep -E "blue =|green =" "$TFVARS_FILE" || echo "None found"
  else
    echo "$TFVARS_FILE not found"
  fi
  
  echo ""
  echo "Terraform state:"
  terraform state list | grep "aws_instance.faz" || echo "No instances in state"
}

# Main script logic
case "$1" in
  --init)
    terraform_init
    ;;
  --deploy-blue)
    deploy_blue
    ;;
  --add-green)
    add_green
    ;;
  --cutover-green)
    cutover_green
    ;;
  --rollback)
    rollback
    ;;
  --status)
    show_status
    ;;
  --help|*)
    show_help
    ;;
esac

exit 0
