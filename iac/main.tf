locals {
  # All variables used in this file should be 
  # added as locals here 
  prefix                = var.prefix
  location              = var.location
  vmsize                = "Standard_${var.vmsize}"
  
  # Common tags should go here
  tags           = {
    created_by = "Terraform"
  }
}


# Create a Virtual Network within the Resource Group
resource "azurerm_virtual_network" "main" {
  name                = "${local.prefix}-vnet"
  address_space       = ["10.200.0.0/16"]
  resource_group_name = data.azurerm_resource_group.project-rg.name
  location            = local.location 
}

# Create a Subnet within the Virtual Network
resource "azurerm_subnet" "internal" {
  name                 = "${local.prefix}-snet-in"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = data.azurerm_resource_group.project-rg.name
  address_prefix       = "10.100.1.0/24"
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

resource "azurerm_network_interface" "main" {
  name                = "${local.prefix}-nic1"
  resource_group_name = data.azurerm_resource_group.project-rg.name
  location            = local.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# TEMPORARY UNTIL BETTER SOLUTION IS IMPLEMENTED
resource "tls_private_key" "bootstrap_private_key" {
    algorithm = "RSA"
    rsa_bits  = "4096"
}

# Create a new Virtual Machine based on the Golden Image
resource "azurerm_virtual_machine" "vm" {
  name                              = "${local.prefix}-vm"
  location                          = local.location 
  resource_group_name               = data.azurerm_resource_group.project-rg.name 
  vm_size                           = local.vmsize

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.managed_id.id]
  }

  storage_image_reference {
    id = data.azurerm_image.fmc-img.id 
  }

  storage_os_disk {
    name                            = "${local.prefix}-os"
    managed_disk_type               = "Standard_LRS"
    caching                         = "ReadWrite"
    create_option                   = "FromImage"
    disk_size_gb                    = 512
  }
  delete_os_disk_on_termination     = true

  storage_data_disk {
    name                            = "${local.prefix}-data"
    create_option                   = "Empty"
    lun                             = 10
    managed_disk_type               = "Premium_LRS"
    disk_size_gb                    = var.datadisk_size_gb 
  }
  delete_data_disks_on_termination  = true

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      path      = "/home/azureuser/.ssh/authorized_keys"
      key_data  = "${chomp(tls_private_key.bootstrap_private_key.public_key_openssh)}"
    }
  }

  os_profile {
    computer_name  = "sequencing${local.prefix}"
    admin_username = "azureuser"
    admin_password = "Password123!"
    custom_data    = base64encode(data.template_file.cloud_init.rendered)
  }
  
  network_interface_ids             = [azurerm_network_interface.main.id,]
 
  provisioner "file" {
    source      = "scripts/initialize.sh"
    destination = "/tmp/initialize.sh"
    connection {
      type        = "ssh"
      user        = "azureuser"
      private_key = tls_private_key.bootstrap_private_key.private_key_pem
      host        = azurerm_network_interface.main.private_ip_address 
    }
  }

  provisioner "remote-exec" {
    inline = [
      "set -x",
      "chmod +x /tmp/initialize.sh",
      "sudo /tmp/initialize.sh"
    ]
    connection {
      type        = "ssh"
      user        = "azureuser"
      private_key = tls_private_key.bootstrap_private_key.private_key_pem
      host        = azurerm_network_interface.main.private_ip_address 
    }
  }
}

#Managed Identity so that VM can access storage account easily
resource "azurerm_user_assigned_identity" "managed_id" {
  name                = "${local.prefix}-mi"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.project-rg.name
  tags                = local.tags
}

resource "azurerm_role_assignment" "blob_contributor" {
  scope                 = data.azurerm_resource_group.project-rg.id 
  role_definition_name  = "Storage Blob Data Contributor"
  principal_id          = azurerm_user_assigned_identity.managed_id.principal_id
}

resource "azurerm_virtual_network_peering" "agent-worker" {
  name                      = "agent-worker"
  resource_group_name       = data.azurerm_virtual_network.agent-vnet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.agent-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.main.id
}

resource "azurerm_virtual_network_peering" "worker-agent" {
  name                      = "worker-agent"
  resource_group_name       = data.azurerm_resource_group.project-rg.name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = data.azurerm_virtual_network.agent-vnet.id
}

