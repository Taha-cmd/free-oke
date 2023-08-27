resource "local_sensitive_file" "tls_cert_file" {
  content  = tls_locally_signed_cert.tls_cert.cert_pem
  filename = "${var.shared_output_directory}/tls-cert.pem"
}

resource "local_sensitive_file" "root_ca_private_key" {
  content  = tls_private_key.root_ca_private_key.private_key_pem
  filename = "${var.shared_output_directory}/root-ca-private-key.pem"
}

resource "local_sensitive_file" "root_ca" {
  content  = tls_self_signed_cert.root_ca.cert_pem
  filename = "${var.shared_output_directory}/root-ca.crt"
}

resource "local_sensitive_file" "tls_cert_private_key" {
  content  = tls_private_key.tls_cert_private_key.private_key_pem
  filename = "${var.shared_output_directory}/tls-cert-private-key.pem"
}

resource "local_file" "sample_ingress_app" {
  content = templatefile("sample-ingress-app.tftpl", {
    namespace        = local.sample_namespace
    top_level_domain = var.top_level_domain
    tls_secret_name  = kubernetes_secret_v1.nginx_tls_secret[local.sample_namespace].metadata[0].name
  })

  filename = "${var.shared_output_directory}/sample-ingress-app.yaml"
}
