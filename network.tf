locals {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaamgkbqra6ewtuwr5pahyfvyeobhoxq7nzwjsj6hwkv42kviyvbqya"
  region         = "eu-frankfurt-1"
}

resource "oci_core_vcn" "vcn" {
  compartment_id = local.compartment_id
  cidr_blocks = [
    "10.0.0.0/16"
  ]

  display_name   = "vcn"
  dns_label      = "vcn"
  is_ipv6enabled = "false"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = local.compartment_id
  display_name   = "internet-gateway"
  enabled        = true
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_route_table" "route_table" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "route-table"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
    description       = "Default route to the outer world (internet)"
  }
}

resource "oci_core_security_list" "security_list" {
  compartment_id = local.compartment_id
  display_name   = "allow-all"
  vcn_id         = oci_core_vcn.vcn.id
  ingress_security_rules {
    description = "all in"
    protocol    = "all"
    source      = "0.0.0.0/0"
  }

  egress_security_rules {
    description = "all out"
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}

resource "oci_core_subnet" "oke_subnets" {

  for_each = {
    "oke-services" = {
      dns_label  = "services"
      cidr_block = "10.0.4.0/24"
    }

    "oke-workers" = {
      dns_label  = "workers"
      cidr_block = "10.0.5.0/24"
    }

    "oke-control-plane" = {
      dns_label  = "control"
      cidr_block = "10.0.6.0/24"
    }
  }

  display_name   = each.key
  compartment_id = local.compartment_id
  cidr_block     = each.value.cidr_block

  dns_label                  = each.value.dns_label
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  vcn_id                     = oci_core_vcn.vcn.id
  route_table_id             = oci_core_route_table.route_table.id
  security_list_ids          = [oci_core_security_list.security_list.id]
}
