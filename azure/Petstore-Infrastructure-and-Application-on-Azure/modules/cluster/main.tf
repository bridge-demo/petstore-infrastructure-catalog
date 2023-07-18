variable kubernetes_cluster_name {}

variable kubernetes_version {
    type = string
    description = "Kubernetes cluster version. Default is set to 1.25.5"
    default = "1.26.0"
}

variable dns_name_prefix {
    type = string
    description = "DNS name prefix to use with the hosted Kubernetes API server FQDN. You will use this to connect to the Kubernetes API when managing containers after creating the cluster. Optional DNS prefix to use with hosted Kubernetes API server FQDN. The DNS prefix must be between 1 and 54 characters long. The prefix can contain only lowercase letters, numbers, and hyphens. The prefix must start with a letter and end with a letter or a number."
    default = "petstorAKSDNS"
}

variable application_tag {
    type = string
    description = "Select an application tag for cam purposes"
}


variable project_tag {
    type = string
    description = "Select a project tag for cam purposes. Please select among: alpha, bravo or charlie"
    validation {
        condition = contains( ["alpha", "bravo", "charlie" ], var.project_tag )
        error_message = "Value should any of the following tags: alpha, bravo, charlie."
    }
}


variable "resource_group_name" {
    type = string
}

variable "resource_group_location" {
  type = string
}



resource "azurerm_kubernetes_cluster" "kubernetes" {

  name                = var.kubernetes_cluster_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_name_prefix
  kubernetes_version  = var.kubernetes_version
  http_application_routing_enabled = true


  default_node_pool {
    name       = "agentpool"
    node_count = 2
    vm_size    = "Standard_D2_v2"
    os_disk_size_gb = 30
    type = "AvailabilitySet"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    application = var.application_tag
    project = var.project_tag
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.kubernetes.kube_config_raw
  sensitive = true
}

output "fqdn" {
  value = azurerm_kubernetes_cluster.kubernetes.http_application_routing_zone_name
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.kubernetes.identity[0].principal_id
}
output "ID" {
  value = azurerm_kubernetes_cluster.kubernetes.id
}


output "application_url" {
  value = "http://jpetstore-web.${azurerm_kubernetes_cluster.kubernetes.http_application_routing_zone_name}" 
}

