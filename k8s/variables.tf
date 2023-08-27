variable "root_compartment_id" {
  description = "The id of the root compartment id. This is the same as the tenancy id"
  type        = string
}

variable "user_ocid" {
  description = " Profile -> My Profile -> OCID"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file to use for authentication against OCI. An API key can be created in the UI under Profile -> My Profile -> API keys"
  type        = string
}

variable "fingerprint" {
  description = "The fingerprint of the created API key"
  type        = string
}

variable "region" {
  type = string
}

variable "top_level_domain" {
  description = "The top level domain to create a wildcard tls certificate for. For example, if you enter example.com, then a wildcard certificate for *.example.com will be created"
  type        = string
}

variable "organization_name" {
  description = "The organization name to use for the self signed root ca"
  type        = string
  default     = "Oke playground"
}

variable "kubernetes_namespaces" {
  description = "Kubernetes namespaces to create. Also note that the the created tls certificate will be automatically uploaded to these namespace to be picked up by the ingress controller"
  type        = set(string)

  validation {
    condition = length(var.kubernetes_namespaces) >= 1
    error_message = "There must be at least one kubernetes namespace"
  }
}
