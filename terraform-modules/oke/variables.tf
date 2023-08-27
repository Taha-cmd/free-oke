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

variable "compartment_name" {
  description = "Name of the compartment that should be created to host the resources in"
  default     = "oke"
  type        = string
}

variable "node_count" {
  description = "OCI offers 4 OCPUS, 24GB RAM and 200GB storage for free. These reources can be used to create up to 4 instances. Enter a value between 1-4 and the resources will be equally spread across the instance count"

  default = 2
  type    = number

  validation {
    condition     = var.node_count >= 1 && var.node_count <= 4
    error_message = "Node count must be between 1 and 4"
  }
}

variable "shared_output_directory" {
  description = "path to output useful generated files into"
  type = string
}