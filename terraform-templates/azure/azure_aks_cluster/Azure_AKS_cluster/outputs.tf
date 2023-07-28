output "kube_config" {
  value = module.cluster.kube_config
  sensitive = true
}

output "cluster_fqdn" {
  value = module.cluster.fqdn
}

output "cluster_id" {
  value = module.cluster.cluster_id
}

output "ID" {
  value = module.cluster.ID
}