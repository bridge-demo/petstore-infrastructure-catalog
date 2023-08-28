provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example" {
  name     = var.group_name
  location = var.group_location
}

variable "group_name" {
  default = "example-resource"
  type    = string
}

variable "group_location" {
default = "East US"
type    = string
}



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

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}


variable "virtualmachine_name" {
  default = "example-machine"
  type    = string
}

variable "virtualmachine_size" {
  default = "Standard_F2"
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
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}