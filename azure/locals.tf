locals {
  template_output_dir_path            = abspath("_out/")
  template_input_dir_path             = abspath("templates/")
  f5xc_azure_vnet_site_resource_group = format("%s-site-rg", var.site_name)
}