module "healthcheck" {
  source                               = "../modules/f5xc/healthcheck"
  f5xc_tenant                          = var.f5xc_tenant
  f5xc_namespace                       = var.f5xc_namespace
  f5xc_healthcheck_name                = format("%s-%s-hc-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_healthcheck_path                = "/"
  f5xc_healthcheck_timeout             = 1
  f5xc_healthcheck_interval            = 15
  f5xc_healthcheck_healthy_threshold   = 1
  f5xc_healthcheck_unhealthy_threshold = 2
}

module "origin_pool" {
  source                                     = "../modules/f5xc/origin-pool"
  f5xc_tenant                                = var.f5xc_tenant
  f5xc_namespace                             = var.f5xc_namespace
  f5xc_origin_pool_name                      = format("%s-%s-op-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_origin_pool_port                      = var.origin_port
  f5xc_origin_pool_no_tls                    = true
  f5xc_origin_pool_origin_servers            = var.origin_servers
  f5xc_origin_pool_healthcheck_names         = module.healthcheck.healthcheck["name"]
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
}

resource "volterra_http_loadbalancer" "lb" {
  name                            = format("%s-%s-lb-%s", var.project_prefix, var.project_name, var.project_suffix)
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
      name = module.origin_pool.origin-pool["name"]
    }
    weight   = 1
    priority = 1
  }

  http {
    dns_volterra_managed = false
  }
}
