output "top_level_domain" {
  value = tls_self_signed_cert.root_ca.subject[0].common_name
}

output "root_ca_file_path" {
  value = abspath(local_sensitive_file.root_ca.filename)
}