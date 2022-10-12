module "apps_site1" {
  depends_on     = [module.azure-site-1a, module.azure-site-1b]
  count          = 1
  source         = "./apps"
  f5xc_tenant    = var.f5xc_tenant
  f5xc_namespace = module.namespace.namespace["name"]
  name           = format("%s-%s-app-site-a-%s", var.project_prefix, var.project_name, var.project_suffix)
  domains        = ["workload.site1"]
  advertise_port = 80
  origin_port    = 8080
  origin_servers = [
    {
      private_ip = {
        ip              = one(module.azure-site-1a[*].workload.private_ip)
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = "mwlab-azure-1a"
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
            name      = "mwlab-azure-1b"
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
  depends_on     = [module.aws-site-2a, module.aws-site-2b]
  count          = 1
  source         = "./apps"
  f5xc_tenant    = var.f5xc_tenant
  f5xc_namespace = module.namespace.namespace["name"]
  name           = format("%s-%s-app-site-a-%s", var.project_prefix, var.project_name, var.project_suffix)
  domains        = ["workload.site2"]
  advertise_port = 80
  origin_port    = 8080
  origin_servers = [
    {
      "private_ip" = {
        ip              = one(module.aws-site-2a[*].aws_workload_private_ip)
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = "mwlab-aws-2a"
            tenant    = var.f5xc_tenant
          }
        }
      },
      "private_ip" = {
        ip              = one(module.aws-site-2b[*].aws_workload_private_ip)
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = "mwlab-aws-2b"
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
  depends_on     = [module.gcp-site-3a, module.gcp-site-3b]
  count          = 1
  source         = "./apps"
  f5xc_tenant    = var.f5xc_tenant
  f5xc_namespace = module.namespace.namespace["name"]
  name           = format("%s-%s-app-site-a-%s", var.project_prefix, var.project_name, var.project_suffix)
  domains        = ["workload.site3"]
  advertise_port = 80
  origin_port    = 8080
  origin_servers = [
    {
      "private_ip" : {
        ip              = one(module.gcp-site-3a[*].workload.private_ip)
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = "mwlab-gcp-3a"
            tenant    = var.f5xc_tenant
          }
        }
      },
      "private_ip" : {
        ip              = one(module.gcp-site-3b[*].workload.private_ip)
        inside_network  = true
        outside_network = false
        site_locator    = {
          site = {
            namespace = var.f5xc_namespace
            name      = "mwlab-gcp-3b"
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

