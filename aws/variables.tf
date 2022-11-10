variable "instance_template_data" {
  type    = map(string)
  default = {}
}

variable "f5xc_aws_cred" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_az_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "outside_subnet_cidr_block" {
  type = string
}

variable "inside_subnet_cidr_block" {
  type = string
}

variable "workload_subnet_cidr_block" {
  type = string
}

variable "workload_subnet_host_ip" {
  type = string
}

variable "ssh_public_key_file" {
  type = string
}

variable "ssh_private_key_file" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "site_name" {
  type = string
}

variable "owner" {
  type = string
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

variable "aws_ec2_instance_script_file_name" {
  type    = string
  default = "instance_custom_data.sh"
}

variable "aws_ec2_instance_script_template_file_name" {
  type    = string
  default = "instance_custom_data.tftpl"
}

variable "allow_cidr_blocks" {
  type    = list(string)
  default = []
}