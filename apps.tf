module "apps_site1" {
  # depends_on     = [module.azure-site-1a, module.azure-site-1b]
  count          = 1
  source         = "./apps"
  domains        = ["workload.site1"]
  f5xc_tenant    = var.f5xc_tenant
  origin_port    = 8080
  project_name   = var.project_name
  project_prefix = var.project_prefix
  project_suffix = var.project_suffix
  f5xc_namespace = module.namespace.namespace["name"]
  advertise_port = 80
  origin_servers = [
    {
      private_ip = {
        ip              = one(module.azure-site-1a[*].workload.private_ip)
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = local.azure-site-1a
            tenant    = var.f5xc_tenant
          }
        }
      }
    },
    {
      private_ip = {
        ip              = one(module.azure-site-1b[*].workload.private_ip)
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = local.azure-site-1b
            tenant    = var.f5xc_tenant
          }
        }
      }
    }
  ]
  advertise_vip   = "10.64.15.254"
  advertise_sites = local.advertise_sites
  providers       = {
    volterra = volterra.default
  }

}

module "apps_site2" {
  # depends_on     = [module.aws-site-2a, module.aws-site-2b]
  count          = 1
  source         = "./apps"
  domains        = ["workload.site2"]
  origin_port    = 8080
  f5xc_tenant    = var.f5xc_tenant
  project_name   = var.project_name
  project_prefix = var.project_prefix
  project_suffix = var.project_suffix
  advertise_port = 80
  f5xc_namespace = module.namespace.namespace["name"]
  origin_servers = [
    {
      "private_ip" = {
        ip              = one(module.aws-site-1a[*].workload["private_ip"])
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = local.aws-site-1a
            tenant    = var.f5xc_tenant
          }
        }
      },
      "private_ip" = {
        ip              = one(module.aws-site-1b[*].workload["private_ip"])
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = local.aws-site-1b
            tenant    = var.f5xc_tenant
          }
        }
      }
    }
  ]
  advertise_vip   = "10.64.15.254"
  advertise_sites = local.advertise_sites
  providers       = {
    volterra = volterra.default
  }
}

module "apps_site3" {
  # depends_on     = [module.gcp-site-1a, module.gcp-site-1b]
  count          = 1
  source         = "./apps"
  domains        = ["workload.site3"]
  f5xc_tenant    = var.f5xc_tenant
  origin_port    = 8080
  project_name   = var.project_name
  project_prefix = var.project_prefix
  project_suffix = var.project_suffix
  f5xc_namespace = module.namespace.namespace["name"]
  advertise_port = 80
  origin_servers = [
    {
      "private_ip" : {
        ip              = one(module.gcp-site-1a[*].workload.private_ip)
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = module.gcp-site-1a.site["name"]
            tenant    = var.f5xc_tenant
          }
        }
      },
      "private_ip" : {
        ip              = one(module.gcp-site-1b[*].workload.private_ip)
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = local.gcp-site-1b
            tenant    = var.f5xc_tenant
          }
        }
      }
    }
  ]
  advertise_vip   = "10.64.15.254"
  advertise_sites = local.advertise_sites
  providers       = {
    volterra = volterra.default
  }
}

