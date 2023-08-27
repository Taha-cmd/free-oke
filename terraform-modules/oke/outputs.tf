output "kubeconfig_path" {
  value = abspath(local_file.kubeconfig.filename)
}

output "k8s_services_subnet_id" {
  value = oci_core_subnet.oke_subnets["oke-services"].id
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

output "compartment_id" {
  value = oci_identity_compartment.compartment.id
}

output "region" {
  value = var.region
}