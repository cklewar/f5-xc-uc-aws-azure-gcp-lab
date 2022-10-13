/*data "azurerm_network_interface" "sli" {
  depends_on          = [module.site_wait_for_online]
  name                = "master-0-sli"
  resource_group_name = module.site.vnet["resource_group"]

}

data "azurerm_network_interface" "slo" {
  depends_on          = [module.site_wait_for_online]
  name                = "master-0-slo"
  resource_group_name = "f5xc-lab-az-01a-site-rg"

}

data "azurerm_public_ip" "pib" {
  depends_on          = [module.site_wait_for_online]
  name                = "master-0-public-ip"
  resource_group_name = "f5xc-lab-az-01a-site-rg"
}*/