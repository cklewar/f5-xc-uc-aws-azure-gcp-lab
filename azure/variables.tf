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

variable "instance_template_data" {
  type = string
}

variable "f5xc_azure_cred" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "azure_region" {
  type = string
}

variable "azure_az" {
  type = string
}

variable "vnet_cidr_block" {
  type = string
}

variable "outside_subnet_cidr_block" {
  type = string
}

variable "inside_subnet_cidr_block" {
  type = string
}

variable "ssh_public_key_file" {
  type    = string
}

variable "allow_cidr_blocks" {
  type = list(string)
}

variable "custom_tags" {
  type    = map(string)
  default = {}
}

variable "f5xc_tenant" {
  type = string
}