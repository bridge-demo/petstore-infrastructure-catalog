output "kube_config" {
  value = module.cluster.kube_config
  sensitive = true
}

output "cluster_fqdn" {
  value = module.cluster.fqdn
}

output "db_user" {
  value = module.mysql.user
}

output "db_password" {
  value = module.mysql.password
  sensitive = false
}

output "db_url" {
  value = module.mysql.url
}

output "application_url" {
  value = "http://jpetstore-web.${module.cluster.fqdn}" 
}