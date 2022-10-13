module "resource_group" {
  source                    = "../modules/azure/resource_group"
  azure_region              = var.azure_region
  azure_resource_group_name = format("%s-rg", var.site_name)
}

module "vnet" {
  source                         = "../modules/azure/virtual_network"
  azure_vnet_name                = format("%s-vnet", var.site_name)
  azure_vnet_primary_ipv4        = var.vnet_cidr_block
  azure_vnet_resource_group_name = module.resource_group.resource_group["name"]
  azure_region                   = module.resource_group.resource_group["location"]
}

module "outside_subnet" {
  source                           = "../modules/azure/subnet"
  azure_vnet_name                  = module.vnet.vnet["name"]
  azure_subnet_name                = format("%s-snet-outside", var.site_name)
  azure_subnet_address_prefixes    = [var.outside_subnet_cidr_block]
  azure_subnet_resource_group_name = module.resource_group.resource_group["name"]
}

module "inside_subnet" {
  source                           = "../modules/azure/subnet"
  azure_vnet_name                  = module.vnet.vnet["name"]
  azure_subnet_name                = format("%s-snet-inside", var.site_name)
  azure_subnet_address_prefixes    = [var.inside_subnet_cidr_block]
  azure_subnet_resource_group_name = module.resource_group.resource_group["name"]
}

module "site" {
  source                                  = "../modules/f5xc/site/azure"
  f5xc_namespace                          = "system"
  f5xc_tenant                             = var.f5xc_tenant
  f5xc_azure_cred                         = var.f5xc_azure_cred
  f5xc_azure_region                       = var.azure_region
  f5xc_azure_site_name                    = var.site_name
  f5xc_azure_ce_gw_type                   = "multi_nic"
  f5xc_azure_existing_vnet_name           = module.vnet.vnet["name"]
  f5xc_azure_vnet_site_resource_group     = local.f5xc_azure_vnet_site_resource_group
  f5xc_azure_existing_vnet_resource_group = module.resource_group.resource_group["name"]
  f5xc_azure_az_nodes                     = {
    node0 : {
      f5xc_azure_az                       = var.azure_az,
      f5xc_azure_vnet_inside_subnet_name  = module.inside_subnet.subnet["name"],
      f5xc_azure_vnet_outside_subnet_name = module.outside_subnet.subnet["name"]
      f5xc_same_as_vnet_resource_group    = false
      f5xc_subnet_resource_grp_name       = module.resource_group.resource_group["name"]
    }
  }
  f5xc_azure_default_blocked_services = false
  f5xc_azure_default_ce_sw_version    = true
  f5xc_azure_default_ce_os_version    = true
  f5xc_azure_no_worker_nodes          = true
  f5xc_azure_total_worker_nodes       = 0
  public_ssh_key                      = var.ssh_public_key_file
  custom_tags                         = var.custom_tags
}

module "site_wait_for_online" {
  depends_on     = [module.site]
  source         = "../modules/f5xc/status/site"
  f5xc_namespace = "system"
  f5xc_site_name = var.site_name
  f5xc_tenant    = var.f5xc_tenant
  f5xc_api_url   = var.f5xc_api_url
  f5xc_api_token = var.f5xc_api_token
}

module "azure_security_group_workload" {
  source                       = "../modules/azure/security_group"
  azure_region                 = var.azure_region
  azure_resource_group_name    = module.resource_group.resource_group["name"]
  azure_security_group_name    = format("%s-workload-nsg", var.site_name)
  azurerm_network_interface_id = element(module.workload.virtual_machine["network_interface_ids"], 0)
  azure_linux_security_rules   = [
    {
      name                       = "ALLOW_ALL"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }
  ]
  custom_tags = var.custom_tags
}

resource "azurerm_route_table" "vip" {
  name                = format("%s-vip", var.site_name)
  location            = module.resource_group.resource_group["location"]
  resource_group_name = module.resource_group.resource_group["name"]
}

resource "azurerm_route" "vip" {
  depends_on             = [module.site_wait_for_online]
  name                   = format("%s-acceptVIP", var.site_name)
  next_hop_type          = "VirtualAppliance"
  address_prefix         = var.allow_cidr_blocks[0]
  route_table_name       = azurerm_route_table.vip.name
  resource_group_name    = module.resource_group.resource_group["name"]
  next_hop_in_ip_address = module.site.vnet["sli"]
}

resource "azurerm_subnet_route_table_association" "vip" {
  subnet_id      = module.inside_subnet.subnet["id"]
  route_table_id = azurerm_route_table.vip.id
}

module "workload" {
  source                                     = "../modules/azure/linux_virtual_machine"
  azure_zone                                 = var.azure_az
  azure_zones                                = [var.azure_az]
  azure_region                               = module.resource_group.resource_group["location"]
  azure_vnet_subnet_id                       = module.inside_subnet.subnet["id"]
  azure_resource_group_name                  = module.resource_group.resource_group["name"]
  azure_virtual_machine_size                 = "Standard_DS1_v2"
  azure_virtual_machine_name                 = format("%s-workload-vm", var.site_name)
  azure_network_interface_name               = format("%s-iface", var.site_name)
  azure_linux_virtual_machine_custom_data    = templatefile(format("%s/%s", local.template_input_dir_path, var.azure_instance_script_template_file_name), var.instance_template_data)
  azure_linux_virtual_machine_admin_username = "ubuntu"
  public_ssh_key                             = var.ssh_public_key_file
  custom_tags                                = var.custom_tags
}