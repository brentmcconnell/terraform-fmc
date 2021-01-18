data "azurerm_resource_group" "project-rg" {
    name = "FMC-RG"
}

data "azurerm_client_config" "current" {}

data "azurerm_image" "fmc-img" {
  name                = "FMCSequencing"
  resource_group_name = "Images"
}
