/**
 * # Aviatrix Controller Build
 *
 * This module builds and launches the Aviatrix Controller VM instance.
 */

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}


# 1. Create an Azure resource group
resource "azurerm_resource_group" "aviatrix_controller_rg" {
  location = var.location
  name     = "${var.controller_name}-rg"
}

# 2. Create the Virtual Network and Subnet
//  Create the Virtual Network
resource "azurerm_virtual_network" "aviatrix_controller_vnet" {
  address_space = [
  var.controller_vnet_cidr]
  location            = var.location
  name                = "${var.controller_name}-vnet"
  resource_group_name = azurerm_resource_group.aviatrix_controller_rg.name
}

//  Create the Subnet
resource "azurerm_subnet" "aviatrix_controller_subnet" {
  name                 = "${var.controller_name}-subnet"
  resource_group_name  = azurerm_resource_group.aviatrix_controller_rg.name
  virtual_network_name = azurerm_virtual_network.aviatrix_controller_vnet.name
  address_prefixes = [
  var.controller_subnet_cidr]
}

// 3. Create Public IP Address
resource "azurerm_public_ip" "aviatrix_controller_public_ip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.aviatrix_controller_rg.location
  name                = "${var.controller_name}-public-ip"
  resource_group_name = azurerm_resource_group.aviatrix_controller_rg.name
}

// 4. Create the Security Group
resource "azurerm_network_security_group" "aviatrix_controller_nsg" {
  location            = azurerm_resource_group.aviatrix_controller_rg.location
  name                = "${var.controller_name}-security-group"
  resource_group_name = azurerm_resource_group.aviatrix_controller_rg.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "https"
    priority                   = "200"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = var.incoming_ssl_cidr
    destination_address_prefix = "*"
    description                = "https-for-vm-management"
  }
}

# 5. Create the Virtual Network Interface Card
//  associate the public IP address with a VM by assigning it to a nic
resource "azurerm_network_interface" "aviatrix_controller_nic" {
  location            = azurerm_resource_group.aviatrix_controller_rg.location
  name                = "${var.controller_name}-network-interface-card"
  resource_group_name = azurerm_resource_group.aviatrix_controller_rg.name
  ip_configuration {
    name                          = "${var.controller_name}-nic"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.aviatrix_controller_subnet.id
    public_ip_address_id          = azurerm_public_ip.aviatrix_controller_public_ip.id
  }
}

# 6. Create the virtual machine
resource "azurerm_linux_virtual_machine" "aviatrix_controller_vm" {
  admin_username                  = var.controller_virtual_machine_admin_username
  admin_password                  = var.controller_virtual_machine_admin_password
  name                            = "${var.controller_name}vm"
  disable_password_authentication = false
  location                        = azurerm_resource_group.aviatrix_controller_rg.location
  network_interface_ids = [
  azurerm_network_interface.aviatrix_controller_nic.id]
  resource_group_name = azurerm_resource_group.aviatrix_controller_rg.name
  size                = var.controller_virtual_machine_size
  //disk
  os_disk {
    name                 = "aviatrix-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "aviatrix-bundle-payg"
    publisher = "aviatrix-systems"
    sku       = "aviatrix-enterprise-bundle-byol"
    version   = "latest"
  }

  plan {
    name      = "aviatrix-enterprise-bundle-byol"
    product   = "aviatrix-bundle-payg"
    publisher = "aviatrix-systems"
  }
}
