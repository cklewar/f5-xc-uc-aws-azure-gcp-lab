locals {
  pattern = format("%s-%s-gcp-\\w+-\\w+", var.project_prefix, var.project_name)
}