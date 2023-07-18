variable resource_group_name {}
variable server_name {}

locals {
    name = "${var.server_name}_AllowAllWindowsAzureIps"
    start = "0.0.0.0"
    end = "0.0.0.0"
}

resource "azurerm_mysql_firewall_rule" "firewalldepl" {
    name                = local.name
    resource_group_name = var.resource_group_name
    server_name         = var.server_name
    start_ip_address    = local.start
    end_ip_address      = local.end
}