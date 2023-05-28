terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.52.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
  }
}
terraform {
  backend "azurerm" {
    storage_account_name = "samindgamesterraform"
    container_name       = "tf-state-mindgames"
    key                  = "mindgamestfstate"
    resource_group_name  = "rg-mindgames-terraform"
  }
}