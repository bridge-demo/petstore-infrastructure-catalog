variable resource_group_name {}
variable resource_group_location {}
variable server_name {}
variable server_user {}
variable serverPassword {}
variable application_tag {}
variable project_tag {}

locals {
  size = 10*1024
  version = "5.7"
  sku_name = "B_Gen5_2" # Basic
}

resource "azurerm_mysql_server" "dbdepl" {

    name                = var.server_name
    location            = var.resource_group_location
    resource_group_name = var.resource_group_name

    administrator_login          = var.server_user
    administrator_login_password = var.serverPassword

    sku_name   = local.sku_name
    storage_mb = local.size
    version    = local.version

    ssl_enforcement_enabled = false
    ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"

    tags = {
        application = var.application_tag
        project = var.project_tag
    }

}

output "url" {
  value = azurerm_mysql_server.dbdepl.fqdn
}

output "user" {
  value = azurerm_mysql_server.dbdepl.administrator_login
}

output "password" {
  value = var.serverPassword
  
}