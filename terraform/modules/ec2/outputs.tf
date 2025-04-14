output "control_node_public_ip" {
  value = aws_instance.control_node[0].public_ip
}

output "managed_node_private_ips" {
  value = aws_instance.ec2[*].private_ip
}

output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.ssh[0].private_key_pem
}

