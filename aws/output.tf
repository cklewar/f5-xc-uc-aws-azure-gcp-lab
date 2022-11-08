output "site" {
  value = {
    vpc_id = module.site.f5xc_aws_vpc["vpc_id"]
    nodes  = module.site.f5xc_aws_vpc["nodes"]
  }
}

/*output "workload" {
  value = {
    private_ip = module.workload.aws_ec2_instance["private_ip"]
    public_ip  = module.workload.aws_ec2_instance["public_ip"]
    public_dns = module.workload.aws_ec2_instance["public_dns"]
  }
}*/