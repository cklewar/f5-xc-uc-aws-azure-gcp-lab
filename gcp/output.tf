output "site" {
  value = module.site.gcp_vpc
}

output "workload" {
  value = {
    "public_ip"  = module.workload.gcp_compute["public_ip"]
    "private_ip" = module.workload.gcp_compute["private_ip"]
  }
}