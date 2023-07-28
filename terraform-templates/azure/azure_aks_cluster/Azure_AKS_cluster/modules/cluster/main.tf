variable kubernetes_cluster_name {
    type = string
    default = "AKSCluster"
    description = "Enter the name of Azure Kubernetes Service Cluster it should contain, only letters, numbers, underscores, and hyphens. The name must start and end with a letter or number."
}

variable kuberntes_dns_prefix {
    type = string
    default = "aksCluster"
    description = "DNS prefix specified when creating the managed cluster. Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length. Changing this forces a new resource to be created."
}

variable kubernetes_cluster_location {
    type = string
    default = "East US"
    description = "The AKS cluster region to deploy the k8s instance "
  
}

variable kubernetes_number_of_nodes {
    type = number
    default = 1
    description = "Number of nodes for the AKS cluster"
}

variable kubernetes_version {
    type = string
    description = "Kubernetes cluster version. Default is set to 1.26.0"
    default = "1.26.0"
}




variable "resource_group_name" {
    type = string
}

variable "resource_group_location" {
  type = string
}



resource "azurerm_kubernetes_cluster" "kubernetes" {

  name                = var.kubernetes_cluster_name
  location            = var.kubernetes_cluster_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.kuberntes_dns_prefix
  kubernetes_version  = var.kubernetes_version
  http_application_routing_enabled = true


  default_node_pool {
    name       = "agentpool"
    node_count = var.kubernetes_number_of_nodes
    vm_size    = "Standard_D2_v2"
    os_disk_size_gb = 30
    type = "AvailabilitySet"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = { }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.kubernetes.kube_config_raw
  sensitive = true
}

output "fqdn" {
  value = azurerm_kubernetes_cluster.kubernetes.fqdn
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.kubernetes.identity[0].principal_id
}
output "ID" {
  value = azurerm_kubernetes_cluster.kubernetes.id
}
