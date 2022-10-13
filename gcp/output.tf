output "site" {
  value = {
    name = module.site.gcp_vpc["name"]
  }
}

output "workload" {
  value = {
    "public_ip"  = module.workload.gcp_compute["nat_ip"]
    "private_ip" = module.workload.gcp_compute["network_ip"]
  }
}