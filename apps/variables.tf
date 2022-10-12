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

variable "origin_servers" {
  type = map(map(string))
}

variable "domains" {
  type = list(string)
}
