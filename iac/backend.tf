terraform {
  required_version = ">=0.12.6"
  backend "azurerm" {
    storage_account_name    = "tfstateacct0693"
    container_name          = "tfcont-0693"
    key                     = "terraform.tfstate"
  }
}
