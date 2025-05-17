/* 
  main.tf
  Primary configuration file defining AWS resources for FortiAnalyzer blue-green deployment
*/

provider "aws" {
  region = var.aws_region
}

# FortiAnalyzer instances - blue/green deployment approach
resource "aws_instance" "faz" {
  for_each = var.faz_ami_ids

  ami                    = each.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  
  tags = {
    Name = "FortiAnalyzer-${each.key}"
    Role = "faz-${each.key}"
    Environment = var.environment
    ManagedBy = "Terraform"
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = true
  }

  # Additional EBS volume for log storage (optional)
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = var.data_volume_size
    volume_type = var.data_volume_type
    encrypted   = true
    delete_on_termination = false  # Preserve data volume on instance termination
  }

  # Lifecycle policy to prevent accidental deletion
  lifecycle {
    prevent_destroy = false  # Set to true in production
  }
}

# Elastic IP for FortiAnalyzer instances
resource "aws_eip" "faz" {
  for_each = var.faz_ami_ids
  
  domain = "vpc"
  
  tags = {
    Name = "FortiAnalyzer-EIP-${each.key}"
    ManagedBy = "Terraform"
  }
}

# EIP association
resource "aws_eip_association" "faz" {
  for_each = var.faz_ami_ids
  
  instance_id   = aws_instance.faz[each.key].id
  allocation_id = aws_eip.faz[each.key].id
}
