data "azurerm_resource_group" "project-rg" {
    name = "FMC-RG"
}

data "azurerm_client_config" "current" {}

data "azurerm_image" "fmc-img" {
  name                = "FMCSequencing"
  resource_group_name = "Images"
}

data "azurerm_public_ip" "pip" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = data.azurerm_resource_group.project-rg.name 
}

data "template_file" "cloud_init" {
  template = file("${path.module}/scripts/cloud-config.yaml")
}
