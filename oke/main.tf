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

    archive = {
      source  = "hashicorp/archive"
      version = "2.4.0"
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

resource "oci_identity_compartment" "compartment" {
  compartment_id = var.root_compartment_id
  name           = "oke"
  description    = "Dedicated compartment to host an oke instance and all its related infrastructure"
}
