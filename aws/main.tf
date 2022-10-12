module "vpc" {
  source             = "../modules/aws/vpc"
  aws_region         = var.aws_region
  aws_az_name        = var.aws_az_name
  aws_vpc_name       = format("%s-%s-vpc-%s", var.project_prefix, var.project_name, var.project_suffix)
  aws_vpc_cidr_block = var.vpc_cidr_block
  custom_tags        = var.custom_tags
}

module "subnet" {
  source          = "../modules/aws/subnet"
  aws_vpc_id      = module.vpc.aws_vpc["id"]
  aws_vpc_subnets = [
    {
      cidr_block              = var.outside_subnet_cidr_block, availability_zone = var.aws_az_name,
      map_public_ip_on_launch = "true", custom_tags = { "Name" = format("%s-%s-sn-outside-%s", var.project_prefix, var.project_name, var.project_suffix) }
    },
    {
      cidr_block              = var.inside_subnet_cidr_block, availability_zone = var.aws_az_name,
      map_public_ip_on_launch = "false", custom_tags = { "Name" = format("%s-%s-sn-inside-%s", var.project_prefix, var.project_name, var.project_suffix) }
    },
    {
      cidr_block              = var.workload_subnet_cidr_block, availability_zone = var.aws_az_name,
      map_public_ip_on_launch = "true", custom_tags = { "Name" = format("%s-%s-sn-workload-%s", var.project_prefix, var.project_name, var.project_suffix) }
    }
  ]
  custom_tags = var.custom_tags
}

module "workload" {
  source                        = "../modules/aws/ec2"
  aws_ec2_instance_name         = format("%s-%s-ec2-%s", var.project_prefix, var.project_name, var.project_suffix)
  aws_ec2_instance_type         = "t3.micro"
  aws_ec2_public_interface_ips  = ["172.16.192.10"]
  aws_ec2_private_interface_ips = ["172.16.193.10"]
  aws_ec2_instance_script       = {
    actions = [
      format("chmod +x /tmp/%s", var.aws_ec2_instance_script_file_name),
      format("sudo /tmp/%s", var.aws_ec2_instance_script_file_name)
    ]
    template_data = var.instance_template_data
  }
  aws_ec2_instance_script_template  = var.aws_ec2_instance_script_template_file_name
  aws_ec2_instance_script_file      = var.aws_ec2_instance_script_file_name
  aws_subnet_private_id             = module.subnet.aws_subnets[format("%s-aws-ec2-test-private-subnet-%s", var.project_prefix, var.project_suffix)]["id"]
  aws_subnet_public_id              = module.subnet.aws_subnets[format("%s-aws-ec2-test-public-subnet-%s", var.project_prefix, var.project_suffix)]["id"]
  aws_az_name                       = var.aws_az_name
  aws_region                        = var.aws_region
  ssh_private_key_file              = var.ssh_private_key_file
  ssh_public_key_file               = var.ssh_public_key_file
  aws_vpc_id                        = module.vpc.aws_vpc["id"]
  template_output_dir_path          = local.template_output_dir_path
  template_input_dir_path           = local.template_input_dir_path
  aws_ec2_instance_custom_data_dirs = [
    {
      name        = "instance_script"
      source      = "${local.template_output_dir_path}/${var.aws_ec2_instance_script_file_name}"
      destination = format("/tmp/%s", var.aws_ec2_instance_script_file_name)
    }
  ]
  custom_tags = var.custom_tags
}

module "site" {
  source                   = "../modules/f5xc/site/aws/vpc"
  f5xc_tenant              = var.f5xc_tenant
  f5xc_aws_cred            = var.f5xc_aws_cred
  f5xc_namespace           = "system"
  f5xc_aws_region          = var.aws_region
  f5xc_aws_ce_gw_type      = "multi_nic"
  f5xc_aws_vpc_name_tag    = var.site_name
  f5xc_aws_vpc_site_name   = var.site_name
  f5xc_aws_vpc_existing_id = module.vpc.aws_vpc["id"]
  f5xc_aws_vpc_az_nodes    = {
    node0 : {
      f5xc_aws_vpc_id              = module.vpc.aws_vpc["id"]
      f5xc_aws_vpc_outside_subnet  = module.subnet.aws_subnets[format("%s-%s-sn-outside-%s", var.project_prefix, var.project_name, var.project_suffix)]["id"],
      f5xc_aws_vpc_inside_subnet   = module.subnet.aws_subnets[format("%s-%s-sn-inside-%s", var.project_prefix, var.project_name, var.project_suffix)]["id"],
      f5xc_aws_vpc_workload_subnet = module.subnet.aws_subnets[format("%s-%s-sn-workload-%s", var.project_prefix, var.project_name, var.project_suffix)]["id"],
      f5xc_aws_vpc_az_name         = var.aws_az_name
    }
  }
  f5xc_aws_vpc_no_worker_nodes         = true
  f5xc_aws_default_ce_os_version       = true
  f5xc_aws_default_ce_sw_version       = true
  f5xc_aws_vpc_use_http_https_port     = true
  f5xc_aws_vpc_inside_static_routes    = [var.workload_subnet_cidr_block]
  f5xc_aws_vpc_use_http_https_port_sli = true
  public_ssh_key                       = file(var.ssh_public_key_file)
  custom_tags                          = var.custom_tags
}

module "site_wait_for_online" {
  depends_on     = [module.site]
  source         = "../modules/f5xc/status/site"
  f5xc_tenant    = var.f5xc_tenant
  f5xc_api_url   = var.f5xc_api_url
  f5xc_api_token = var.f5xc_api_token
  f5xc_namespace = "system"
  f5xc_site_name = var.site_name
}