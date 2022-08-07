variable "f5xc_azure_cred" {
  type = string
}

variable "f5xc_azure_site_name" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_azure_region" {
  type = string
}

variable "f5xc_azure_default_ce_os_version" {
  type = bool
}

variable "f5xc_azure_ce_os_version" {
  type    = string
  default = ""
}

variable "f5xc_azure_default_ce_sw_version" {
  type = bool
}

variable "f5xc_azure_ce_sw_version" {
  type    = string
  default = ""
}

variable "f5xc_azure_ce_machine_type" {
  type    = string
  default = "Standard_D4_v4"
}

variable "f5xc_azure_vnet_primary_ipv4" {
  type = string
  default = ""
}

variable "f5xc_azure_vnet_resource_group" {
  type = string
  default = ""
}

variable "f5xc_azure_vnet_name" {
  type = string
  default = ""
}

variable "f5xc_azure_az_nodes" {
  type    = map(map(string))
  default = {
    node0 : {
      f5xc_azure_vnet_inside_subnet = "192.168.168.0/24", f5xc_azure_vnet_outside_subnet = "192.168.169.0/24"
      f5xc_azure_az                 = "1"
    }
  }
}

variable "f5xc_azure_global_network_name" {
  type    = list(string)
  default = []
}

variable "f5xc_azure_no_global_network" {
  type    = bool
  default = true
}

variable "f5xc_azure_no_outside_static_routes" {
  type    = bool
  default = true
}

variable "f5xc_azure_no_inside_static_routes" {
  type    = bool
  default = true
}

variable "f5xc_azure_no_network_policy" {
  type    = bool
  default = true
}

variable "f5xc_azure_no_forward_proxy" {
  type    = bool
  default = true
}

variable "f5xc_azure_ce_gw_type" {
  type    = string
  default = "multi_nic"
}

variable "f5xc_azure_ce_certified_hw" {
  type    = map(string)
  default = {
    multi_nic  = "azure-byol-multi-nic-voltmesh"
    single_nic = "azure-byol-voltmesh"
    app_stack  = "azure-byol-voltstack-combo"
  }
}

variable "f5xc_azure_default_blocked_services" {
  type = bool
}

variable "f5xc_azure_logs_streaming_disabled" {
  type    = bool
  default = true
}

variable "f5xc_azure_no_local_control_plane" {
  type    = bool
  default = true
}

variable "f5xc_azure_site_kind" {
  type    = string
  default = "azure_vnet_site"
}

variable "f5xc_azure_ce_disk_size" {
  type    = string
  default = "80"
}

variable "public_ssh_key" {
  type = string
}

variable "f5xc_azure_worker_nodes_per_az" {
  type    = number
  default = 0
}

variable "f5xc_azure_total_worker_nodes" {
  type    = number
  default = 0
}

variable "f5xc_azure_no_worker_nodes" {
  type = bool
}

variable "f5xc_tf_params_action" {
  type    = string
  default = "apply"
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}
