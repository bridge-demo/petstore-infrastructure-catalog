variable resource_group_name {}

variable workspace_name {}

variable application_tag {}

variable project_tag {}

variable resource_workspace_region {}


resource "azurerm_log_analytics_workspace" "wkspc" {
    name                = var.workspace_name
    location            = var.resource_workspace_region
    resource_group_name = var.resource_group_name
    sku = "Standalone"

    tags = {
        application = var.application_tag
        project = var.project_tag
    }

}

resource "azurerm_log_analytics_solution" "logs" {
    
    solution_name         = "ContainerInsights"
    location              = var.resource_workspace_region
    resource_group_name   = var.resource_group_name
    workspace_resource_id = azurerm_log_analytics_workspace.wkspc.id
    workspace_name        = var.workspace_name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }

    tags = {
        application = var.application_tag
        project = var.project_tag
    } 

}