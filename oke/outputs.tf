output "kubeconfig_path" {
  value = abspath(local_file.kubeconfig.filename)
}

output "k8s_services_subnet_id" {
  value = oci_core_subnet.oke_subnets["oke-services"].id
}