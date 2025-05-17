# AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ca-central-1"
}

# Environment tag
variable "environment" {
  description = "Environment name (e.g., prod, dev, staging)"
  type        = string
  default     = "prod"
}

# FortiAnalyzer AMI IDs for blue/green deployment
variable "faz_ami_ids" {
  description = "Map of FortiAnalyzer AMI IDs for blue/green deployment"
  type        = map(string)
  default     = {}
}

# Instance type
variable "instance_type" {
  description = "EC2 instance type for FortiAnalyzer"
  type        = string
  default     = "m5.large"
}

# Network configuration
variable "subnet_id" {
  description = "Subnet ID where FortiAnalyzer will be deployed"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to FortiAnalyzer instances"
  type        = list(string)
}

# SSH key
variable "key_name" {
  description = "Name of the SSH key pair for instance access"
  type        = string
}

# Volume configuration
variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 50
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"
}

variable "data_volume_size" {
  description = "Size of the data volume in GB"
  type        = number
  default     = 100
}

variable "data_volume_type" {
  description = "Type of the data volume"
  type        = string
  default     = "gp3"
}
