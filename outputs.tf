/*
  outputs.tf
  Defines outputs to display after terraform apply
*/

# FortiAnalyzer Instance IDs
output "faz_instance_ids" {
  description = "IDs of the FortiAnalyzer instances"
  value = {
    for k, v in aws_instance.faz : k => v.id
  }
}

# FortiAnalyzer Public IPs
output "faz_public_ips" {
  description = "Public IP addresses of the FortiAnalyzer instances"
  value = {
    for k, v in aws_eip.faz : k => v.public_ip
  }
}

# FortiAnalyzer Private IPs
output "faz_private_ips" {
  description = "Private IP addresses of the FortiAnalyzer instances"
  value = {
    for k, v in aws_instance.faz : k => v.private_ip
  }
}

# SSH connection commands
output "ssh_commands" {
  description = "SSH commands to connect to FortiAnalyzer instances"
  value = {
    for k, v in aws_eip.faz : k => "ssh -i /path/to/${var.key_name}.pem admin@${v.public_ip}"
  }
}

# Active FortiAnalyzer instances
output "active_instances" {
  description = "Currently active FortiAnalyzer instances"
  value = keys(var.faz_ami_ids)
}
