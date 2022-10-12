module "namespace" {
  source              = "./modules/f5xc/namespace"
  f5xc_namespace_name = var.custom_namespace
  providers           = {
    volterra = volterra.default
  }
}

module "virtual_site" {
  source                                = "./modules/f5xc/site/virtual"
  f5xc_namespace                        = "shared"
  f5xc_virtual_site_name                = format("%s-%s-vs-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_virtual_site_type                = "CUSTOMER_EDGE"
  f5xc_virtual_site_selector_expression = ["site_mesh_group in (aws-azure-gcp)"]
  providers                             = {
    volterra = volterra.default
  }
}

module "smg" {
  source                           = "./modules/f5xc/site-mesh-group"
  f5xc_tenant                      = var.f5xc_tenant
  f5xc_namespace                   = var.f5xc_namespace
  f5xc_virtual_site_name           = module.virtual_site.virtual-site["name"]
  f5xc_site_mesh_group_name        = format("%s-%s-smg-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_virtual_site_selector       = ["site_mesh_group in (aws-azure-gcp)"]
  f5xc_site_2_site_connection_type = "hub_mesh"
  providers                        = {
    volterra = volterra.default
  }
}

module "azure-site-1a" {
  count                     = var.build_azure == true ? 1 : 0
  source                    = "./azure"
  azure_az                  = "1"
  site_name                 = format("%s-%s-azure-%sa", var.project_prefix, var.project_name, var.project_suffix)
  azure_region              = "westus2"
  vnet_cidr_block           = "10.64.16.0/22"
  allow_cidr_blocks         = ["10.64.15.0/24"]
  inside_subnet_cidr_block  = "10.64.17.0/24"
  outside_subnet_cidr_block = "10.64.16.0/24"
  workload_user_data        = templatefile(var.workload_user_data_file, {
    tailscale_key          = var.tailscale_key, tailscale_hostname = format("%s-%s-azure-workload-%sa", var.project_prefix, var.project_name, var.project_suffix),
    grafana_agent_stack_id = var.grafana_agent_stack_id, grafana_api_key = var.grafana_api_key,
    grafana_api_url        = var.grafana_api_url
  })
  f5xc_tenant         = var.f5xc_tenant
  f5xc_api_url        = var.f5xc_api_url
  f5xc_api_token      = var.f5xc_api_token
  f5xc_azure_cred     = var.f5xc_azure_cred
  project_name        = var.project_name
  project_prefix      = var.project_prefix
  project_suffix      = var.project_suffix
  ssh_public_key_file = file(var.ssh_public_key_file)
  custom_tags         = {
    Owner           = var.owner_tag
    site_mesh_group = module.smg.site-mesh-group["name"]
  }
  providers = {
    aws      = aws.eu_north_1
    volterra = volterra.default
  }
}

module "azure-site-1b" {
  count                     = var.build_azure == true ? 1 : 0
  source                    = "./azure"
  azure_region              = "westus2"
  azure_az                  = "2"
  site_name                 = format("%s-%s-azure-%sb", var.project_prefix, var.project_name, var.project_suffix)
  vnet_cidr_block           = "10.64.16.0/22"
  outside_subnet_cidr_block = "10.64.16.0/24"
  inside_subnet_cidr_block  = "10.64.17.0/24"
  allow_cidr_blocks         = ["10.64.15.0/24"]

  workload_user_data = templatefile(var.workload_user_data_file, {
    tailscale_key          = var.tailscale_key, tailscale_hostname = format("%s-%s-azure-workload-%sb", var.project_prefix, var.project_name, var.project_suffix),
    grafana_agent_stack_id = var.grafana_agent_stack_id, grafana_api_key = var.grafana_api_key,
    grafana_api_url        = var.grafana_api_url
  })
  f5xc_tenant         = var.f5xc_tenant
  f5xc_api_url        = var.f5xc_api_url
  f5xc_api_token      = var.f5xc_api_token
  f5xc_azure_cred     = var.f5xc_azure_cred
  project_name        = var.project_name
  project_prefix      = var.project_prefix
  project_suffix      = var.project_suffix
  ssh_public_key_file = file(var.ssh_public_key_file)
  custom_tags         = {
    Owner           = var.owner_tag
    site_mesh_group = module.smg.site-mesh-group["name"]
  }
  providers = {
    aws      = aws.eu_north_1
    volterra = volterra.default
  }
}

module "aws-site-2a" {
  count                      = var.build_aws == true ? 1 : 0
  source                     = "./aws"
  site_name                  = format("%s-%s-aws-%sa", var.project_prefix, var.project_name, var.project_suffix)
  aws_region                 = "eu-north-1"
  aws_az_name                = "eu-north-1a"
  vpc_cidr_block             = "10.64.16.0/22"
  allow_cidr_blocks          = ["10.64.0.0/16"]
  inside_subnet_cidr_block   = "10.64.17.0/24"
  outside_subnet_cidr_block  = "10.64.16.0/24"
  workload_subnet_cidr_block = "10.64.18.0/24"
  workload_user_data         = templatefile(var.workload_user_data_file, {
    tailscale_key          = var.tailscale_key, tailscale_hostname = format("%s-%s-aws-workload-%sa", var.project_prefix, var.project_name, var.project_suffix),
    grafana_agent_stack_id = var.grafana_agent_stack_id, grafana_api_key = var.grafana_api_key,
    grafana_api_url        = var.grafana_api_url
  })
  f5xc_tenant         = var.f5xc_tenant
  f5xc_api_url        = var.f5xc_api_url
  f5xc_api_token      = var.f5xc_api_token
  f5xc_aws_cred       = var.f5xc_aws_cred
  project_name        = var.project_name
  project_prefix      = var.project_prefix
  project_suffix      = var.project_suffix
  ssh_public_key_file = file(var.ssh_public_key_file)
  custom_tags         = {
    Owner           = var.owner_tag
    site_mesh_group = module.smg.site-mesh-group["name"]
  }
  providers = {
    aws      = aws.eu_north_1
    volterra = volterra.default
  }
}

module "aws-site-2b" {
  count                      = var.build_aws == true ? 1 : 0
  source                     = "./aws"
  site_name                  = format("%s-%s-aws-%sb", var.project_prefix, var.project_name, var.project_suffix)
  aws_region                 = "eu-north-1"
  aws_az_name                = "eu-north-1b"
  vpc_cidr_block             = "10.64.16.0/22"
  allow_cidr_blocks          = ["10.64.0.0/16"]
  inside_subnet_cidr_block   = "10.64.17.0/24"
  outside_subnet_cidr_block  = "10.64.16.0/24"
  workload_subnet_cidr_block = "10.64.18.0/24"
  workload_user_data         = templatefile(var.workload_user_data_file, {
    tailscale_key          = var.tailscale_key, tailscale_hostname = format("%s-%s-aws-workload-%sb", var.project_prefix, var.project_name, var.project_suffix),
    grafana_agent_stack_id = var.grafana_agent_stack_id, grafana_api_key = var.grafana_api_key,
    grafana_api_url        = var.grafana_api_url
  })
  f5xc_tenant         = var.f5xc_tenant
  f5xc_api_url        = var.f5xc_api_url
  f5xc_api_token      = var.f5xc_api_token
  f5xc_aws_cred       = var.f5xc_aws_cred
  project_name        = var.project_name
  project_prefix      = var.project_prefix
  project_suffix      = var.project_suffix
  ssh_public_key_file = file(var.ssh_public_key_file)
  custom_tags         = {
    Owner           = var.owner_tag
    site_mesh_group = module.smg.site-mesh-group["name"]
  }
  providers = {
    aws      = aws.eu_north_1
    volterra = volterra.default
  }
}

module "gcp-site-3a" {
  count                     = var.build_gcp == true ? 1 : 0
  source                    = "./gcp"
  site_name                 = format("%s-%s-gcp-%sa", var.project_prefix, var.project_name, var.project_suffix)
  gcp_region                = "europe-west6"
  gcp_az_name               = "europe-west6-a"
  allow_cidr_blocks         = ["10.64.15.0/24"]
  network_cidr_block        = "10.64.16.0/22"
  inside_subnet_cidr_block  = "10.64.17.0/24"
  outside_subnet_cidr_block = "10.64.16.0/24"
  workload_user_data        = templatefile(var.workload_user_data_file, {
    tailscale_key          = var.tailscale_key, tailscale_hostname = format("%s-gcp-workload-%sa", var.project_prefix, var.project_suffix),
    grafana_agent_stack_id = var.grafana_agent_stack_id, grafana_api_key = var.grafana_api_key,
    grafana_api_url        = var.grafana_api_url
  })
  f5xc_tenant         = var.f5xc_tenant
  f5xc_api_url        = var.f5xc_api_url
  f5xc_api_token      = var.f5xc_api_token
  f5xc_gcp_cred       = var.f5xc_gcp_cred
  ssh_public_key_file = file(var.ssh_public_key_file)
  custom_tags         = {
    Owner           = var.owner_tag
    site_mesh_group = module.smg.site-mesh-group["name"]
  }
  providers = {
    google   = google.europe_west6
    volterra = volterra.default
  }
}

module "gcp-site-3b" {
  count                     = var.build_gcp == true ? 1 : 0
  source                    = "./gcp"
  site_name                 = format("%s-%s-gcp-%sb", var.project_prefix, var.project_name, var.project_suffix)
  gcp_region                = "europe-west6"
  gcp_az_name               = "europe-west6-b"
  allow_cidr_blocks         = ["10.64.15.0/24"]
  network_cidr_block        = "10.64.16.0/22"
  inside_subnet_cidr_block  = "10.64.17.0/24"
  outside_subnet_cidr_block = "10.64.16.0/24"
  workload_user_data        = templatefile(var.workload_user_data_file, {
    tailscale_key          = var.tailscale_key, tailscale_hostname = format("%s-lab-gcp-workload-%sb", var.project_prefix, var.project_suffix),
    grafana_agent_stack_id = var.grafana_agent_stack_id, grafana_api_key = var.grafana_api_key,
    grafana_api_url        = var.grafana_api_url
  })
  f5xc_tenant         = var.f5xc_tenant
  f5xc_api_url        = var.f5xc_api_url
  f5xc_api_token      = var.f5xc_api_token
  f5xc_gcp_cred       = var.f5xc_gcp_cred
  ssh_public_key_file = file(var.ssh_public_key_file)
  custom_tags         = {
    Owner           = var.owner_tag
    site_mesh_group = module.smg.site-mesh-group["name"]
  }
  providers = {
    google   = google.europe_west6
    volterra = volterra.default
  }
}