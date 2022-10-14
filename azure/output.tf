output "workload" {
  value = module.workload.virtual_machine
}

output "sli_ip" {
  value = module.site.vnet["sli_ip"]
}

output "slo_ip" {
  value = module.site.vnet["slo_ip"]
}

output "public_ip" {
  value = module.site.vnet["public_ip"]
}