provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example" {
  name     = var.group_name
  location = var.group_location
}

variable "group_name" {
  default = "tf-test"
  type    = string
}

variable "group_location" {
default = "East US"
type    = string
}

## NETWORKING

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Dynamic"

}

resource "azurerm_network_security_group" "example" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}


resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}


resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# ///NETWORKIN

variable "virtualmachine_name" {
  default = "tf-test"
  type    = string
}

variable "virtualmachine_size" {
  default = "Standard_B2s"
  type    = string
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = var.virtualmachine_name
  
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.virtualmachine_size
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
  
  disable_password_authentication = false
  admin_password = "Mcmprocks123"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "87-gen2"
    version   = "latest"
  }
}


# resource "azurerm_virtual_machine_extension" "example" {
#   name                 = "install-scripts"
#   virtual_machine_id   = azurerm_linux_virtual_machine.example.id
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   settings = <<SETTINGS
#  {
#   "commandToExecute": "sudo yum install python2 -y && sudo cp /usr/bin/python2 /usr/bin/python"
#  }
# SETTINGS

# }




### OUTPUTS

output "public_ip_address" {
  description = "Publich Ip address of the deployed VM"
  value = azurerm_public_ip.example.ip_address
}

output "admin_username" {

  description = "Username to SSH into the VM"
  value = azurerm_linux_virtual_machine.example.admin_username
}

output "admin_password" {

  description = "Username password to SSH into the VM"
  value = azurerm_linux_virtual_machine.example.admin_password
  sensitive = true
}


