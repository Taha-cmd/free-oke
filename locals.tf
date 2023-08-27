locals {
  # output any generated files into this path (kubeconfig, ssh keys etc)
  artifact_output_directory = "${path.module}/outputs"
}