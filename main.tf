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

    archive = {
      source  = "hashicorp/archive"
      version = "2.4.0"
    }
  }
}

# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
provider "oci" {
  tenancy_ocid     = local.tenancy_ocid
  user_ocid        = local.user_ocid
  region           = local.region
  auth             = local.auth
  fingerprint      = local.fingerprint
  private_key_path = local.private_key_path
}

# TODO: come up with a better way
# either use kubeconfig or figure out how to output the ca data
provider "helm" {
  kubernetes {
    host     = oci_containerengine_cluster.oke_cluster.endpoints[0].public_endpoint
    insecure = true
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "oci"
      args        = ["ce", "cluster", "generate-token", "--cluster-id", oci_containerengine_cluster.oke_cluster.id, "--region", local.region]
    }
  }
}

# TODO: make this work for greenfield
provider "kubernetes" {
  config_path    = "${local.artifact_output_directory}/kubeconfig"
  config_context = "context-ctbuzrzsvha"
}
