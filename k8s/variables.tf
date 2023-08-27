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