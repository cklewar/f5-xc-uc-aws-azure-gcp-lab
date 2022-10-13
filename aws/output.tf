output "aws_vpc_id" {
  value = module.vpc.aws_vpc["id"]
}

/*output "aws_subnet_id" {
  value = module.subnet.aws_subnets[*]
}

output "workload" {
  value = {
    "private_ip" = module.workload.aws_ec2_instance["private_ip"]
    "public_ip"  = module.workload.aws_ec2_instance["public_ip"]
  }
}

output "sli_private_ip" {
  depends_on = [module.site_wait_for_online]
  value      = data.aws_network_interface.sli.private_ip
}

output "slo_private_ip" {
  depends_on = [module.site_wait_for_online]
  value      = data.aws_network_interface.slo.private_ip
}

output "slo_public_ip" {
  depends_on = [module.site_wait_for_online]
  value      = data.aws_network_interface.slo.association[0]["public_ip"]
}*/