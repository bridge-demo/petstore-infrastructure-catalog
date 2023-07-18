variable resource_group_name {}
variable ClusterId {}
variable snowScriptUrl {}
variable snowUser {}
variable snowPassword {}

locals {
    baseSnowUrl = format( "%s.service-now.com", split(".service-now.com", var.snowScriptUrl )[0] )
}

resource "azurerm_monitor_action_group" "RT_postIncident" {
  name                = "RT_postIncident"
  resource_group_name = var.resource_group_name
  short_name          = "pstIncident"
  webhook_receiver {
    name                    = "RT_postIncident"
    service_uri             = "${var.snowScriptUrl}?baseurl=${local.baseSnowUrl}&user=${var.snowUser}&password=${var.snowPassword}"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "example" {
  name                 = "RT High CPU"
  resource_group_name  = var.resource_group_name
  scopes               = [ var.ClusterId ]
  description         = "Action will be triggered when Transactions count is greater than 50."
  frequency           = "PT1H"
  window_size         = "PT1H"
  auto_mitigate       = false
  severity            = 0
  
  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5
  }
  depends_on = [
    azurerm_monitor_action_group.RT_postIncident
  ]
  action {
    action_group_id = azurerm_monitor_action_group.RT_postIncident.id
  }
}
