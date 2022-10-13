module "gcp_network" {
  source                                      = "../modules/gcp/network"
  gcp_project_name                            = var.gcp_project_id
  gcp_compute_network_name                    = format("%s-network", var.site_name)
  gcp_compute_network_routing_mode            = "REGIONAL"
  gcp_compute_network_auto_create_subnetworks = false
}

module "gcp_subnetwork_outside" {
  source                               = "../modules/gcp/subnetwork"
  gcp_region                           = var.gcp_region
  gcp_compute_network_id               = module.gcp_network.vpc_network["id"]
  gcp_compute_subnetwork_name          = format("%s-sn-outside", var.site_name)
  gcp_compute_subnetwork_ip_cidr_range = var.outside_subnet_cidr_block

}

module "gcp_subnetwork_inside" {
  source                               = "../modules/gcp/subnetwork"
  gcp_region                           = var.gcp_region
  gcp_compute_network_id               = module.gcp_network.vpc_network["id"]
  gcp_compute_subnetwork_name          = format("%s-sn-inside", var.site_name)
  gcp_compute_subnetwork_ip_cidr_range = var.inside_subnet_cidr_block
}

module "workload" {
  source                                  = "../modules/gcp/compute"
  gcp_zone_name                           = var.gcp_az_name
  gcp_compute_instance_target_tags        = ["ssh", "http"]
  gcp_compute_instance_machine_name       = format("%s-gcp-compute", var.site_name)
  gcp_compute_instance_machine_type       = "n1-standard-1"
  gcp_compute_instance_network_interfaces = [
    {
      subnetwork_name = module.gcp_subnetwork_inside.subnetwork["id"]
      access_config   = {}
    }
  ]
  gcp_compute_instance_labels = {
    webserver = "true"
  }
  public_ssh_key = var.ssh_public_key_file
}

module "gcp_compute_firewall_internal" {
  source                       = "../modules/gcp/firewall"
  gcp_project_name             = var.gcp_project_id
  gcp_compute_firewall_name    = format("%s-%s-fw-internal", var.site_name, module.workload.gcp_compute["name"])
  compute_firewall_allow_rules = [
    {
      protocol = "icmp"
    },
    {
      protocol = "tcp"
      ports    = ["0-65535"]
    },
    {
      protocol = "udp"
      ports    = ["0-65535"]
    }
  ]
  gcp_compute_firewall_source_ranges = [
    var.inside_subnet_cidr_block,
    var.outside_subnet_cidr_block
  ]
  gcp_compute_firewall_compute_network = module.gcp_network.vpc_network["name"]
}

module "gcp_compute_firewall_http" {
  source                       = "../modules/gcp/firewall"
  gcp_project_name             = var.gcp_project_id
  gcp_compute_firewall_name    = format("%s-%s-fw-http", var.site_name, module.workload.gcp_compute["name"])
  compute_firewall_allow_rules = [
    {
      protocol = "tcp"
      ports    = ["80", "8080"]
    }
  ]
  gcp_compute_firewall_target_tags     = ["http"]
  gcp_compute_firewall_source_ranges   = var.allow_cidr_blocks
  gcp_compute_firewall_compute_network = module.gcp_network.vpc_network["name"]
}

module "gcp_compute_firewall_ssh" {
  source                       = "../modules/gcp/firewall"
  gcp_project_name             = var.gcp_project_id
  gcp_compute_firewall_name    = format("%s-%s-fw-allow-bastion", var.site_name, module.workload.gcp_compute["name"])
  compute_firewall_allow_rules = [
    {
      protocol = "tcp"
      ports    = ["22"]
    }
  ]
  gcp_compute_firewall_target_tags     = ["ssh"]
  gcp_compute_firewall_source_ranges   = ["0.0.0.0/0"]
  gcp_compute_firewall_compute_network = module.gcp_network.vpc_network["name"]
}

resource "google_compute_route" "vip" {
  depends_on             = [module.site]
  name                   = format("%s-%s-network-route-%s", var.site_name)
  dest_range             = var.allow_cidr_blocks[0]
  network                = module.gcp_network.vpc_network["name"]
  # next_hop_instance      = regex(local.pattern, module.site.gcp_vpc["params"])
  next_hop_instance      = ""
  next_hop_instance_zone = var.gcp_az_name
  priority               = 100
}

module "site" {
  source                            = "../modules/f5xc/site/gcp"
  f5xc_tenant                       = var.f5xc_tenant
  f5xc_gcp_cred                     = var.f5xc_gcp_cred
  f5xc_namespace                    = "system"
  f5xc_gcp_region                   = var.gcp_region
  f5xc_gcp_site_name                = var.site_name
  f5xc_gcp_zone_names               = [var.gcp_az_name]
  f5xc_gcp_ce_gw_type               = "multi_nic"
  f5xc_gcp_node_number              = 1
  f5xc_gcp_inside_subnet_name       = module.gcp_subnetwork_inside.subnetwork["name"]
  f5xc_gcp_inside_network_name      = module.gcp_network.vpc_network["name"]
  f5xc_gcp_outside_primary_ipv4     = var.outside_subnet_cidr_block
  f5xc_gcp_default_ce_sw_version    = true
  f5xc_gcp_default_ce_os_version    = true
  f5xc_gcp_default_blocked_services = true
  public_ssh_key                    = var.ssh_public_key_file
  custom_tags                       = var.custom_tags
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