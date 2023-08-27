locals {
  subnets = {
    # for k8s LoadBalancer services
    "oke-services" = {
      dns_label  = "services"
      cidr_block = "10.0.4.0/24"
    }

    # for the nodes
    "oke-workers" = {
      dns_label  = "workers"
      cidr_block = "10.0.5.0/24"
    }

    # for the control plane
    "oke-control-plane" = {
      dns_label  = "control"
      cidr_block = "10.0.6.0/24"
    }
  }
}
