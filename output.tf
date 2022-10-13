output "azure-site-1a" {
  value = module.azure-site-1a
}

output "azure-site-1b" {
  value = module.azure-site-1b
}

/*output "aws-site-1a" {
  value = module.aws-site-1a
}

output "aws-site-1b" {
  value = module.aws-site-1b
}

output "gcp-site-1a" {
  value = module.gcp-site-1a
}

output "gcp-site-1b" {
  value = module.gcp-site-1b
}*/

output "f5xc_custom_namespace" {
  value = {
    id   = module.namespace.namespace["id"]
    name = module.namespace.namespace["name"]
  }
}

output "azure_resource_group" {
  value = {
    id   = module.azure-site-1a[0].resource_group["id"]
    name = module.azure-site-1a[0].resource_group["name"]
  }
}