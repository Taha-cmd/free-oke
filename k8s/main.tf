terraform {
  required_version = "1.5.5"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.9.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
provider "oci" {
  tenancy_ocid     = var.root_compartment_id
  user_ocid        = var.user_ocid
  region           = var.region
  auth             = "APIKey"
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

provider "helm" {
  kubernetes {
    config_path = "${local.shared_output_directory}/kubeconfig"
  }
}

provider "kubernetes" {
  config_path = "${local.shared_output_directory}/kubeconfig"
}

data "terraform_remote_state" "oke" {
  backend = "local"

  config = {
    path = abspath("${path.module}/../oke/terraform.tfstate")
  }
}
