output "kubeconfig" {
  value = data.azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}

output "app_url" {
  value = "http://jpetstore-web.${data.azurerm_kubernetes_cluster.aks_cluster.http_application_routing_zone_name}"
  sensitive = false
}