variable "instance_user_data" {
  type = string
}

variable "f5xc_gcp_cred" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_az_name" {
  type = string
}

variable "site_name" {
  type = string
}

variable "network_cidr_block" {
  type = string
}

variable "f5xc_gcp_inside_network_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_inside_subnet_name" {
  type    = string
  default = ""
}

variable "outside_subnet_cidr_block" {
  type = string
}

variable "inside_subnet_cidr_block" {
  type = string
}

variable "ssh_public_key_file" {
  type = string
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

variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "01"
}

variable "project_name" {
  type    = string
  default = "lab"
}

variable "gcp_project_id" {
  type = string
}

