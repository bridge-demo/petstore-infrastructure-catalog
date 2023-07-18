provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags = {
    application = var.application_tag
    project = var.project_tag    
  }
}

module "operations" {
  source = "./modules/operations"  
  application_tag = var.application_tag
  project_tag = var.project_tag
  workspace_name = var.workspace_name
  resource_workspace_region = var.resource_group_location
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}

data "azurerm_client_config" "current" {}

module "cluster" {
  source = "./modules/cluster"
  application_tag = var.application_tag
  project_tag = var.project_tag
  resource_group_location = var.resource_group_location
  resource_group_name = var.resource_group_name
  kubernetes_cluster_name = var.kubernetes_cluster_name
  depends_on = [
    module.operations
  ]
}

module "cluster_role" {
  source = "./modules/cluster_role"  
  application_tag = var.application_tag
  project_tag = var.project_tag  
  cluster_name = var.kubernetes_cluster_name
  resource_group_name = var.resource_group_name
  cluster_id = module.cluster.cluster_id
  depends_on = [
    module.cluster
  ]
}

module "mysql" {
  source = "./modules/mysql"  
  application_tag = var.application_tag
  project_tag = var.project_tag
  server_user = var.administrator_login
  serverPassword = var.administratorPassword
  server_name = var.server_name
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
  depends_on = [
    module.cluster
  ]
}

module "firewall" {
  source = "./modules/firewall"
  server_name = var.server_name
  resource_group_name = var.resource_group_name
  depends_on = [
    module.mysql
  ]
}

module "snowAlerts" {
  source = "./modules/snowAlerts"
  ClusterId = module.cluster.ID
  resource_group_name = var.resource_group_name
  snowScriptUrl = var.snowScriptUrl
  snowUser = var.snowUser
  snowPassword = var.snowPassword
  depends_on = [
    module.cluster
  ]
}
