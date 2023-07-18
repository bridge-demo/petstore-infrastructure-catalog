variable resource_group_name {}

variable application_tag {}

variable project_tag {}

variable cluster_name {}

variable cluster_id {}

/*
resource "azurerm_role_definition" "role_assignment_contributor" {
    name  = "Role Assignment Owner"
    scope = azurerm_management_group.root.id
    description = "A role designed for writing and deleting role assignments"

    permissions {
        actions = [
            "Microsoft.Authorization/roleAssignments/write",
            "Microsoft.Authorization/roleAssignments/delete",
        ]
        not_actions = []
    }

    assignable_scopes = [
        azurerm_management_group.root.id
    ]
}
*/

/*
data "azurerm_client_config" "conf" {}

resource "azurerm_role_assignment" "example" {
  principal_id = var.cluster_id
  role_definition_id = "3913510d-42f4-4e42-8a64-420c390055eb"
  scope = "/subscriptions/${data.azurerm_client_config.conf.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.ContainerService/managedClusters/${var.cluster_name}"
}
*/


/*
locals {
  deployment_name = "ClusterMonitoring"
  deployment_mode = "Incremental"
  version = "2019-08-01"
}

resource "azurerm_resource_group_template_deployment" "monitoringdepl" {
    name = local.deployment_name
    deployment_mode = local.deployment_mode
    resource_group_name = var.resource_group_name
    tags = {
        application = var.application_tag
        project = var.project_tag
    }
    parameters_content = jsonencode({
        "kubernetesClusterName" = {
            value = var.cluster_name
        }
        "resourceGroupName" = {
            value = var.resource_group_name
        }
        "clusterId" = {
            value = var.cluster_id
        }
    })
    template_content = <<TEMPLATE
        {
            "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
                "kubernetesClusterName": { "type": "string" },
                "resourceGroupName": { "type": "string" },
                "clusterId": { "type": "string" }
            },
            "resources": [{
                "type": "Microsoft.ContainerService/managedClusters/providers/roleAssignments",
                "apiVersion": "2022-01-01-preview",
                "name": "[concat(parameters('kubernetesClusterName'), '/', 'Microsoft.Authorization/', guid('AksClusterMonitoringMetricPulisher', uniqueString(deployment().name, parameters('resourceGroupName'))))]",
                "properties": {
                    "roleDefinitionId": "[concat('/subscriptions/', subscription().subscriptionId, '/providers/Microsoft.Authorization/roleDefinitions/', '3913510d-42f4-4e42-8a64-420c390055eb')]",
                    "principalId": "[parameters('clusterId')]",
                    "scope": "[resourceId('Microsoft.ContainerService/managedClusters',parameters('kubernetesClusterName'))]"
                }
            }]            
        }
    TEMPLATE
}
*/


data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name = var.cluster_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_client_config" "example" {}

resource "azurerm_role_assignment" "role-assignment" {
  scope = data.azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id = data.azurerm_client_config.example.object_id
}
