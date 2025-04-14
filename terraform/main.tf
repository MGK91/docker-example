provider "aws" {
  region = var.region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "ec2" {
  source          = "./modules/ec2"
  subnet_ids      = module.vpc.public_subnet_ids
  ami_id          = var.ami_id
  vpc_id          = module.vpc.vpc_id
  instance_count  = var.instance_count
  ssh_key_name    = var.ssh_key_name
  key_s3_bucket   = var.s3_bucket
  install_ansible = true
}
