provider "azurerm" {
  features {}
}

locals {
  unique_resource_group_name = "${var.resource_group_name}-${uuid()}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.unique_resource_group_name
  location = var.resource_group_location
  tags = { }
}


data "azurerm_client_config" "current" {}

module "cluster" {
  source = "./modules/cluster"
  resource_group_location = var.resource_group_location
  resource_group_name = local.unique_resource_group_name
  kubernetes_cluster_name = var.kubernetes_cluster_name
  kubernetes_number_of_nodes = var.kubernetes_number_of_nodes
  kuberntes_dns_prefix = var.kuberntes_dns_prefix
  kubernetes_cluster_location = var.kubernetes_cluster_location
  kubernetes_version = var.kubernetes_version

  depends_on = [ azurerm_resource_group.rg ]
}

module "cluster_role" {
  source = "./modules/cluster_role"  
  cluster_name = var.kubernetes_cluster_name
  resource_group_name = local.unique_resource_group_name
  cluster_id = module.cluster.cluster_id
  depends_on = [
    module.cluster
  ]
}