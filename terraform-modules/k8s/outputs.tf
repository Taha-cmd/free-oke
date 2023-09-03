output "top_level_domain" {
  value = var.top_level_domain
}

output "root_ca_file_path" {
  value = abspath(local_sensitive_file.root_ca.filename)
}

output "load_balancer_ip" {
  value = data.oci_load_balancers.load_balancer.load_balancers[0].ip_address_details[0].ip_address
}

output "sample_ingress_app_file_path" {
  value = abspath(local_file.sample_ingress_app.filename)
}

output "tls_secret_name" {
  value = values(kubernetes_secret_v1.nginx_tls_secret)[0].metadata[0].name
}