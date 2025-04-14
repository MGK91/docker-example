variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 3
}
variable "install_ansible" {
  description = "Whether to install Ansible on first node"
  type        = bool
  default     = true
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ssh_key_name" {
  description = "Name for SSH key"
  type        = string
  default     = "ansible-ssh-key"
}

variable "key_s3_bucket" {
  description = "S3 bucket to upload private key to"
  type        = string
}

