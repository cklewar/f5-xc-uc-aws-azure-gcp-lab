locals {
  advertise_sites = [
    format("%s-%s-azure-%sa", var.project_prefix, var.project_name, var.project_suffix), format("%s-%s-azure-%sb", var.project_prefix, var.project_name, var.project_suffix),
    format("%s-%s-aws-%sa", var.project_prefix, var.project_name, var.project_suffix), format("%s-%s-aws-%sb", var.project_prefix, var.project_name, var.project_suffix),
    format("%s-%s-gcp-%sa", var.project_prefix, var.project_name, var.project_suffix), format("%s-%s-gcp-%sb", var.project_prefix, var.project_name, var.project_suffix)
  ]
}
