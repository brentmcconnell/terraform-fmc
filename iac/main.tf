locals {
  # All variables used in this file should be 
  # added as locals here 
  prefix                = "${var.prefix}-0693"
  location              = var.location
  vault_name            = "${local.prefix}-vault"
  
  # Common tags should go here
  tags           = {
    created_by = "Terraform"
  }
}

# Create a Virtual Network within the Resource Group
resource "azurerm_virtual_network" "main" {
  name                = "${local.prefix}-Vnet"
  address_space       = ["10.100.0.0/16"]
  resource_group_name = data.azurerm_resource_group.project-rg.name
  location            = local.location 
}

# Create a Subnet within the Virtual Network
resource "azurerm_subnet" "internal" {
  name                 = "${local.prefix}-snet-in"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = data.azurerm_resource_group.project-rg.name
  address_prefix       = "10.100.2.0/24"
}

# Create a Network Security Group with some rules
resource "azurerm_network_security_group" "main" {
  name                = "${local.prefix}-NSG"
  location            = local.location 
  resource_group_name = data.azurerm_resource_group.project-rg.name 

  security_rule {
    name                       = "allow_SSH"
    description                = "Allow SSH access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "${local.prefix}-pip"
  resource_group_name = data.azurerm_resource_group.project-rg.name
  location            = local.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "main" {
  name                = "${local.prefix}-nic1"
  resource_group_name = data.azurerm_resource_group.project-rg.name
  location            = local.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# Create a network internal interface for VMs and attach the PIP and the NSG
resource "azurerm_network_interface" "internal" {
  name                      = "${local.prefix}-nic2"
  location                  = local.location 
  resource_group_name       = data.azurerm_resource_group.project-rg.name 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a new Virtual Machine based on the Golden Image
resource "azurerm_linux_virtual_machine" "vm" {
  name                              = "${local.prefix}-DEVOPS01"
  location                          = local.location 
  resource_group_name               = data.azurerm_resource_group.project-rg.name 
  size                              = "Standard_DS12_v2"
  source_image_id                   = data.azurerm_image.fmc-img.id
  disable_password_authentication   = false
  admin_username                    = "adminuser"
  admin_password                    = "Password123!"

  os_disk {
    storage_account_type            = "Standard_LRS"
    caching                         = "ReadWrite"
  }
  
  network_interface_ids             = [azurerm_network_interface.main.id,]

}

resource "azurerm_managed_disk" "data-disk" {
  name                 = "${local.prefix}-datadisk1"
  resource_group_name  = data.azurerm_resource_group.project-rg.name
  location             = local.location 
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 16000
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.data-disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}
