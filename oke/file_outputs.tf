resource "local_sensitive_file" "node_pool_public_key" {
  content  = tls_private_key.node_pool_ssh_key_pair.public_key_openssh
  filename = "${local.shared_output_directory}/node-pool-ssh-public-key.pub"
}

resource "local_sensitive_file" "node_pool_private_key" {
  content  = tls_private_key.node_pool_ssh_key_pair.private_key_openssh
  filename = "${local.shared_output_directory}/node-pool-ssh-private-key.pem"
}

resource "local_file" "kubeconfig" {
  content  = data.oci_containerengine_cluster_kube_config.kubeconfig.content
  filename = "${local.shared_output_directory}/kubeconfig"
}

data "archive_file" "outputs" {

  depends_on = [
    local_sensitive_file.node_pool_public_key,
    local_sensitive_file.node_pool_private_key,
    local_file.kubeconfig,
  ]

  type        = "zip"
  source_dir  = local.shared_output_directory
  output_path = "${path.module}/outputs.zip"
}
