terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "azapi" {}