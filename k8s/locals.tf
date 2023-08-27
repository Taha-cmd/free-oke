locals {
  # output any generated files into this path (kubeconfig, ssh keys etc)
  artifact_output_directory = "${path.module}/../outputs"
  shared_output_directory   = "${path.module}/../outputs"

  compartment_id = "ocid1.compartment.oc1..aaaaaaaamgkbqra6ewtuwr5pahyfvyeobhoxq7nzwjsj6hwkv42kviyvbqya"
  region         = "eu-frankfurt-1"
}
