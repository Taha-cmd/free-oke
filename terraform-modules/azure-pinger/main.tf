terraform {
  required_version = "1.5.5"

  required_providers {
    azurerm = {
      source  = "Hashicorp/azurerm"
      version = "3.71.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

data "terraform_remote_state" "k8s" {
  backend = "local"

  config = {
    path = abspath("${path.module}/../k8s/terraform.tfstate")
  }
}