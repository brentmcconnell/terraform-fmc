terraform {
  required_version = ">=0.12.6"
  backend "azurerm" {
    skip_provider_registration = true
    storage_account_name    = "tfstateacct0693"
    container_name          = "tfcont-0693"
    key                     = "terraform.tfstate"
    access_key              = "C+42I7MBDtPkTnt2iYJ5eMVFafMrpHhAgd4LZsgRGInlAFIIJOShzM5qfHfXqYy6ns6RjVUI7a+cF0+wiJ7bkQ=="
  }
}
