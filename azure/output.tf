output "workload" {
  value = module.workload.virtual_machine
}

output "sli_ip" {
  depends_on = [module.site_wait_for_online]
  value      = module.site.vnet["sli"]
}

output "slo_ip" {
  depends_on = [module.site_wait_for_online]
  value      = module.site.vnet["slo"]
}

output "public_ip" {
  depends_on = [module.site_wait_for_online]
  value      = module.site.vnet["public_ip"]
}