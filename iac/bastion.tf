# Create a Subnet within the Virtual Network
resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = data.azurerm_resource_group.project-rg.name
  address_prefix       = "10.200.2.0/24"
}

resource "azurerm_public_ip" "bastion-pip" {
  count               = var.enable-bastion ? 1 : 0
  name                = "${local.prefix}-pip"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.project-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-host" {
  count               = var.enable-bastion ? 1 : 0
  name                = "${local.prefix}-bastion"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.project-rg.name

  ip_configuration {
    name                 = "ip-config"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id 
    public_ip_address_id = azurerm_public_ip.bastion-pip[count.index].id
  }
}

