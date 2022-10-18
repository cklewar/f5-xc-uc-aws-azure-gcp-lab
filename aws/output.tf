output "aws_vpc_id" {
  value = module.vpc.aws_vpc["id"]
}

output "aws_subnet_id" {
  value = module.subnet.aws_subnets[*]
}

/*output "workload" {
  value = {
    private_ip = module.workload.aws_ec2_instance["private_ip"]
    public_ip  = module.workload.aws_ec2_instance["public_ip"]
    public_dns = module.workload.aws_ec2_instance["public_dns"]
  }
}*/

output "sli_private_ip" {
  value = module.site.f5xc_aws_vpc["sli_ip"]
}

output "slo_private_ip" {
  value = module.site.f5xc_aws_vpc["slo_ip"]
}

output "slo_public_ip" {
  value = module.site.f5xc_aws_vpc["public_ip"]
}