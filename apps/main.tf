module "healthcheck" {
  source                               = "../modules/f5xc/healthcheck"
  f5xc_tenant                          = var.f5xc_tenant
  f5xc_namespace                       = var.f5xc_namespace
  f5xc_healthcheck_name                = format("%s-hc", var.app_site_name)
  f5xc_healthcheck_path                = "/"
  f5xc_healthcheck_timeout             = 1
  f5xc_healthcheck_interval            = 15
  f5xc_healthcheck_healthy_threshold   = 1
  f5xc_healthcheck_unhealthy_threshold = 2
}

/*module "origin_pool" {
  source                                     = "../modules/f5xc/origin-pool"
  f5xc_tenant                                = var.f5xc_tenant
  f5xc_namespace                             = var.f5xc_namespace
  f5xc_origin_pool_name                      = format("%s-op", var.app_site_name)
  f5xc_origin_pool_port                      = var.origin_port
  f5xc_origin_pool_no_tls                    = true
  f5xc_origin_pool_origin_servers            = var.f5xc_origin_pool_origin_servers
  f5xc_origin_pool_healthcheck_names         = [module.healthcheck.healthcheck["name"]]
  f5xc_origin_pool_endpoint_selection        = "DISTRIBUTED"
  f5xc_origin_pool_loadbalancer_algorithm    = "LB_OVERRIDE"
  f5xc_origin_pool_disable_outlier_detection = false
  f5xc_origin_pool_outlier_detection         = {
    interval                    = 5000
    consecutive_5xx             = 2
    base_ejection_time          = 10000
    max_ejection_percent        = 100
    consecutive_gateway_failure = 2
  }
}*/

resource "volterra_origin_pool" "op" {
  name                   = format("%s-op", var.app_site_name)
  namespace              = var.f5xc_namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = var.origin_port
  no_tls                 = true

  dynamic "origin_servers" {
    for_each = var.f5xc_origin_pool_origin_servers.private_ip
    content {
      private_ip {
        ip             = origin_servers.value.ip
        inside_network = origin_servers.value.inside_network
        site_locator {
          site {
            namespace = origin_servers.value.site_locator.site.namespace
            name      = origin_servers.value.site_locator.site.name
            tenant    = origin_servers.value.site_locator.site.tenant
          }
        }
      }
    }
  }

  advanced_options {
    disable_outlier_detection = false
    outlier_detection {
      base_ejection_time          = 10000
      consecutive_5xx             = 2
      consecutive_gateway_failure = 2
      interval                    = 5000
      max_ejection_percent        = 100
    }
  }

  healthcheck {
    name = module.healthcheck.healthcheck["name"]
  }
}

resource "volterra_http_loadbalancer" "lb" {
  name                            = format("%s-lb", var.app_site_name)
  domains                         = var.domains
  namespace                       = var.f5xc_namespace
  disable_waf                     = true
  no_challenge                    = true
  disable_rate_limit              = true
  service_policies_from_namespace = true

  advertise_custom {
    dynamic "advertise_where" {
      for_each = var.advertise_sites
      content {
        port = var.advertise_port
        site {
          ip      = var.advertise_vip
          network = "SITE_NETWORK_INSIDE"
          site {
            name      = advertise_where.value
            namespace = "system"
          }
        }
      }
    }
  }

  default_route_pools {
    pool {
      name = volterra_origin_pool.op.name
    }
    weight   = 1
    priority = 1
  }

  http {
    dns_volterra_managed = false
  }
}
