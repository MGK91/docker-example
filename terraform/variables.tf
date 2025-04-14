variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "instance_count" {
  default = 1
}

variable "ami_id" {
  default = "ami-00a929b66ed6e0de6"
}
variable "ssh_key_name" {
  default = "ansible-key"
}
variable "s3_bucket" {
  default = "my-ansible-ssh-key-bucket"
}

