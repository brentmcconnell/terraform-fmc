data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "project-rg" {
    name              = var.project-rg
}

data "azurerm_image" "fmc-img" {
  name                = var.vmImage 
  resource_group_name = var.project-rg
}

data "template_file" "cloud_init" {
  template = file("${path.module}/cloud-init/cloud-config.yaml")
}

data "azurerm_virtual_network" "agent-vnet" {
    name                  = var.agent-vnet-name
    resource_group_name   = var.agent-vnet-rg
}
