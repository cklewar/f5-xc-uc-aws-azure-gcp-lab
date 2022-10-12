data "aws_network_interface" "slo" {
  depends_on = [module.site_wait_for_online]
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
}

data "aws_network_interface" "sli" {
  depends_on = [module.site_wait_for_online]
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
}