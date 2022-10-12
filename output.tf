output "azure-site-1a" {
  value = module.azure-site-1a
}

output "azure-site-1b" {
  value = module.azure-site-1b
}

output "aws-site-2a" {
  value = module.aws-site-2a
}

output "aws-site-2b" {
  value = module.aws-site-2b
}

output "gcp-site-3a" {
  value = module.gcp-site-3a
}

output "gcp-site-3b" {
  value = module.gcp-site-3b
}

output "namespace" {
  value = module.namespace.namespace["id"]
}