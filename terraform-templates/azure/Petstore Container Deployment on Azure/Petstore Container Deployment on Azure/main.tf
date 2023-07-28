provider "azurerm" {
  features {}
}



data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}


