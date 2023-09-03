resource "oci_core_vcn" "vcn" {
  compartment_id = oci_identity_compartment.compartment.id
  cidr_blocks = [
    local.vcn_cidr_block
  ]

  display_name   = "oke-vcn"
  dns_label      = "vcn"
  is_ipv6enabled = false
}

# There are two options to enable outbound traffic in a vcn:
# 1) private subnet + nat gateway
# 2) public subnet + internet gateway
# The first option is the prefered one from a security perspective
# However, a gateway, although free, requires a paid account
# Therefore, we go the second option
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "internet-gateway"
  enabled        = true
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_route_table" "route_table" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "route-table"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
    description       = "Default route to the outer world (internet)"
  }
}

# We might consider restricting this :/
resource "oci_core_security_list" "security_list" {
  compartment_id = oci_identity_compartment.compartment.id
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

  for_each = local.subnets

  display_name   = each.key
  compartment_id = oci_identity_compartment.compartment.id
  cidr_block     = each.value.cidr_block

  dns_label                  = each.value.dns_label
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  vcn_id                     = oci_core_vcn.vcn.id
  route_table_id             = oci_core_route_table.route_table.id
  security_list_ids          = [oci_core_security_list.security_list.id]
}