output "resource_group" {
  value = module.resource_group.resource_group
}

output "azure_vnet" {
  value = module.vnet.vnet
}

output "outside_subnet" {
  value = module.outside_subnet.subnet
}

output "inside_subnet" {
  value = module.inside_subnet.subnet
}

output "workload" {
  value = module.workload.virtual_machine
}

output "sli_private_ip" {
  depends_on = [module.site_wait_for_online]
  value      = data.azurerm_network_interface.sli.private_ip_address
}

output "slo_private_ip" {
  depends_on = [module.site_wait_for_online]
  value      = data.azurerm_network_interface.slo.private_ip_address
}

output "slo_public_ip" {
  depends_on = [module.site_wait_for_online]
  value      = data.azurerm_public_ip.pib.ip_address
}