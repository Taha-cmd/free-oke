data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = local.compartment_id
}

resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id = local.compartment_id
  name           = "oke-cluster"
  cluster_pod_network_options {
    cni_type = "FLANNEL_OVERLAY"
  }

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.oke_subnets["oke-control-plane"].id
  }

  kubernetes_version = "v1.27.2"

  vcn_id = oci_core_vcn.vcn.id
  type   = "BASIC_CLUSTER" # ENHANCED_CLUSTER

  options {
    service_lb_subnet_ids = [oci_core_subnet.oke_subnets["oke-services"].id]
  }
}

data "oci_containerengine_cluster_kube_config" "kubeconfig" {
  cluster_id = oci_containerengine_cluster.oke_cluster.id

  endpoint      = "PUBLIC_ENDPOINT" # LEGACY_KUBERNETES,PUBLIC_ENDPOINT,PRIVATE_ENDPOINT,VCN_HOSTNAME.
  token_version = "2.0.0"
}

locals {
  node_count = 2
}

resource "tls_private_key" "node_pool_ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "oci_containerengine_node_pool" "oke_node_pool" {
  cluster_id     = oci_containerengine_cluster.oke_cluster.id
  compartment_id = local.compartment_id
  name           = "worker-pool"

  kubernetes_version = oci_containerengine_cluster.oke_cluster.kubernetes_version

  node_config_details {
    node_pool_pod_network_option_details {
      cni_type = "FLANNEL_OVERLAY"
    }
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
      subnet_id           = oci_core_subnet.oke_subnets["oke-workers"].id
    }
    size = local.node_count
  }

  # enhanced cluster feature
  node_pool_cycling_details {
    is_node_cycling_enabled = false
  }

  // We get 4 OCPUS, 24 GB ram and 200 GB for free 
  // https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm
  node_shape = "VM.Standard.A1.Flex"
  node_shape_config {
    memory_in_gbs = floor(24 / local.node_count)
    ocpus         = floor(4 / local.node_count)
  }

  node_source_details {
    boot_volume_size_in_gbs = 50
    // https://docs.oracle.com/en-us/iaas/images/image/9512f09f-6a8a-4a46-96b6-f5d0e72eb41b/
    // Oracle Linux 8 aarch
    // Ubuntu is supposed to be supported according to the docs, but it is not working :/
    image_id    = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaar4w4vy27jugfspfquaal6w2uih4i7a35abjl7cs6inaiw3pgzssq"
    source_type = "image"
  }

  ssh_public_key = tls_private_key.node_pool_ssh_key_pair.public_key_openssh
}

output "node_ips" {
  value = oci_containerengine_node_pool.oke_node_pool.nodes.*.public_ip
}

output "cluster_id" {
  value = oci_containerengine_cluster.oke_cluster.id
}

output "cluster_public_endpoint" {
  value = oci_containerengine_cluster.oke_cluster.endpoints[0].public_endpoint
}