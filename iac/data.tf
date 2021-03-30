data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "project-rg" {
    name              = var.project-rg
}

data "azurerm_image" "fmc-img" {
  name                = "mySequencerImg-01a49f5"
  resource_group_name = var.project-rg
}

data "template_file" "cloud_init" {
  template = file("${path.module}/cloud-init/cloud-config.yaml")
}
