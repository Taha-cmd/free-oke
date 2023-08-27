resource "local_sensitive_file" "node_pool_public_key" {
  content  = tls_private_key.node_pool_ssh_key_pair.public_key_openssh
  filename = "${local.artifact_output_directory}/node-pool-ssh-public-key.pub"
}

resource "local_sensitive_file" "node_pool_private_key" {
  content  = tls_private_key.node_pool_ssh_key_pair.private_key_openssh
  filename = "${local.artifact_output_directory}/node-pool-ssh-private-key.pem"
}

resource "local_sensitive_file" "tls_cert_file" {
  content  = tls_locally_signed_cert.tls_cert.cert_pem
  filename = "${local.artifact_output_directory}/tls-cert.pem"
}

resource "local_file" "kubeconfig" {
  content  = data.oci_containerengine_cluster_kube_config.kubeconfig.content
  filename = "${local.artifact_output_directory}/kubeconfig"
}

resource "local_sensitive_file" "root_ca_private_key" {
  content  = tls_private_key.root_ca_private_key.private_key_pem
  filename = "${local.artifact_output_directory}/root-ca-private-key.pem"
}

resource "local_sensitive_file" "root_ca" {
  content  = tls_self_signed_cert.root_ca.cert_pem
  filename = "${local.artifact_output_directory}/root-ca.crt"
}

resource "local_sensitive_file" "tls_cert_private_key" {
  content  = tls_private_key.tls_cert_private_key.private_key_pem
  filename = "${local.artifact_output_directory}/tls-cert-private-key.pem"
}

data "archive_file" "outputs" {

  depends_on = [
    local_sensitive_file.node_pool_public_key,
    local_sensitive_file.node_pool_private_key,
    local_sensitive_file.tls_cert_file,
    local_sensitive_file.tls_cert_private_key,
    local_sensitive_file.root_ca,
    local_sensitive_file.root_ca_private_key,
    local_file.kubeconfig,
  ]

  type        = "zip"
  source_dir  = local.artifact_output_directory
  output_path = "${path.module}/outputs.zip"
}
