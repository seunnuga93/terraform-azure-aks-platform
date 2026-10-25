terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # State lives in an Azure storage account. Create it once with scripts/bootstrap-state.sh.
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "REPLACE_ME"
    container_name       = "tfstate"
    key                  = "aks-platform/dev.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}
