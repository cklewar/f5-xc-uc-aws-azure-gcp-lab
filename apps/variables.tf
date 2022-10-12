variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
}

variable "project_name" {
  type    = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "origin_port" {
  type    = number
  default = 8080
}

variable "advertise_port" {
  type    = number
  default = 80
}

variable "advertise_vip" {
  type = string
}

variable "advertise_sites" {
  type = list(string)
}

variable "f5xc_origin_pool_origin_servers" {}

variable "domains" {
  type = list(string)
}
