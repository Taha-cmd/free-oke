data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = oci_identity_compartment.compartment.id
}

resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id = oci_identity_compartment.compartment.id
  name           = "oke-cluster"

  cluster_pod_network_options {
    # With FLANNEL, every pod gets assigned an IP from a cluster-internal network
    # The VCN-native cni will assign every pod an IP from the actual subnet, which will require a NAT gateway for outbound traffic
    # But NAT gateways can only be created in paid accounts
    cni_type = "FLANNEL_OVERLAY"
  }

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.oke_subnets["oke-control-plane"].id
  }

  kubernetes_version = var.kubernetes_version

  vcn_id = oci_core_vcn.vcn.id
  type   = "BASIC_CLUSTER"

  options {
    service_lb_subnet_ids = [oci_core_subnet.oke_subnets["oke-services"].id]
  }
}

data "oci_containerengine_cluster_kube_config" "kubeconfig" {
  cluster_id = oci_containerengine_cluster.oke_cluster.id

  endpoint      = "PUBLIC_ENDPOINT" # LEGACY_KUBERNETES,PUBLIC_ENDPOINT,PRIVATE_ENDPOINT,VCN_HOSTNAME.
  token_version = "2.0.0"
}
