resource "tls_private_key" "root_ca_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "root_ca" {
  private_key_pem = tls_private_key.root_ca_private_key.private_key_pem

  subject {
    common_name  = "taha.dev"
    organization = "Taha's org"
  }

  allowed_uses = ["cert_signing"]

  validity_period_hours = 24 * 30 * 12 * 10 # 10 years
  is_ca_certificate     = true
}

resource "tls_private_key" "tls_cert_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "tls_cert_signing_request" {
  private_key_pem = tls_private_key.tls_cert_private_key.private_key_pem #

  subject {
    common_name  = "*.taha.dev"
    organization = "Taha's org"
  }

  dns_names = ["taha.dev", "*.taha.dev"]
  uris      = ["https://taha.dev", "https://*.taha.dev"]
}

resource "tls_locally_signed_cert" "tls_cert" {
  allowed_uses = [
    "server_auth"
  ]

  ca_cert_pem           = tls_self_signed_cert.root_ca.cert_pem
  ca_private_key_pem    = tls_self_signed_cert.root_ca.private_key_pem
  cert_request_pem      = tls_cert_request.tls_cert_signing_request.cert_request_pem
  set_subject_key_id    = true
  validity_period_hours = 24 * 30 * 12 * 5 # 5 years
}