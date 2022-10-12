variable "instance_user_data" {
  type = string
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

variable "ssh_public_key_file" {
  type = string
}

variable "allow_cidr_blocks" {
  type = list(string)
}

variable "f5xc_tenant" {
  type = string
}

variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
}

variable "project_name" {
  type = string
}

variable "site_name" {
  type = string
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

