locals {
  azure-site-1a = format("%s-%s-az-%sa", var.project_prefix, var.project_name, var.project_suffix)
  azure-site-1b = format("%s-%s-az-%sb", var.project_prefix, var.project_name, var.project_suffix)
  aws-site-1a   = format("%s-%s-aws-%sa", var.project_prefix, var.project_name, var.project_suffix)
  aws-site-1b   = format("%s-%s-aws-%sb", var.project_prefix, var.project_name, var.project_suffix)
  gcp-site-1a   = format("%s-%s-gcp-%sa", var.project_prefix, var.project_name, var.project_suffix)
  gcp-site-1b   = format("%s-%s-gcp-%sb", var.project_prefix, var.project_name, var.project_suffix)

  /*azure-site-1a_tailscale_hostname = format("%s-%s-azure-workload-%sa", var.project_prefix, var.project_name, var.project_suffix)
  azure-site-1b_tailscale_hostname = format("%s-%s-azure-workload-%sb", var.project_prefix, var.project_name, var.project_suffix)
  aws-site-1a_tailscale_hostname   = format("%s-%s-aws-workload-%sa", var.project_prefix, var.project_name, var.project_suffix)
  aws-site-1b_tailscale_hostname   = format("%s-%s-aws-workload-%sb", var.project_prefix, var.project_name, var.project_suffix)
  gcp-site-1a_tailscale_hostname   = format("%s-%s-gcp-workload-%sa", var.project_prefix, var.project_name, var.project_suffix)
  gcp-site-1b_tailscale_hostname   = format("%s-%s-gcp-workload-%sb", var.project_prefix, var.project_name, var.project_suffix)*/

  advertise_sites = [
    local.azure-site-1a, local.azure-site-1b,
    local.aws-site-1a, local.aws-site-1b,
    local.gcp-site-1a, local.gcp-site-1b
  ]
}
