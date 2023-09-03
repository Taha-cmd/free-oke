resource "tls_private_key" "node_pool_ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "oci_containerengine_node_pool" "oke_node_pool" {
  cluster_id     = oci_containerengine_cluster.oke_cluster.id
  compartment_id = oci_identity_compartment.compartment.id
  name           = "worker-pool"

  kubernetes_version = oci_containerengine_cluster.oke_cluster.kubernetes_version

  node_config_details {

    node_pool_pod_network_option_details {
      cni_type = oci_containerengine_cluster.oke_cluster.cluster_pod_network_options[0].cni_type
    }

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
      subnet_id           = oci_core_subnet.oke_subnets["oke-workers"].id
    }

    size = var.node_count
  }

  # enhanced cluster feature
  node_pool_cycling_details {
    is_node_cycling_enabled = false
  }

  // We get 4 OCPUS, 24 GB ram and 200 GB for free 
  // https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm
  node_shape = "VM.Standard.A1.Flex"
  node_shape_config {
    memory_in_gbs = floor(24 / var.node_count)
    ocpus         = floor(4 / var.node_count)
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
