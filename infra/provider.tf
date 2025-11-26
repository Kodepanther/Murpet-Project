# infra/provider.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # We keep this empty to inject details via the Pipeline
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}