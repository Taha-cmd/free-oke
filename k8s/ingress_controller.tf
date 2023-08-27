resource "helm_release" "nginx_ingress_controller" {
  name             = "nginx-ingress-controller"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-controller"
  atomic           = true
  create_namespace = true
  cleanup_on_fail  = true
  force_update     = true

  values = [yamlencode(local.ingress_controller_values)]
}

data "oci_load_balancers" "load_balancer" {
  depends_on     = [helm_release.nginx_ingress_controller]
  compartment_id = data.terraform_remote_state.oke.outputs.compartment_id

  lifecycle {
    postcondition {
      condition     = length(self.load_balancers) == 1
      error_message = "Expected to find exactly one load balancer, but found ${length(self.load_balancers)}"
    }

    postcondition {
      condition     = length(self.load_balancers[0].ip_address_details) == 1
      error_message = "Expected load balancer ${self.load_balancers[0].display_name} to have exactly one public ip address, but found ${length(self.load_balancers[0].ip_address_details)}"
    }
  }
}

resource "kubernetes_namespace_v1" "kubernetes_namespaces" {
  for_each = toset(var.kubernetes_namespaces)

  metadata {
    name = each.key
  }
}

resource "kubernetes_secret_v1" "nginx_tls_secret" {
  for_each = toset(var.kubernetes_namespaces)

  type = "kubernetes.io/tls"

  metadata {
    name      = "nginx-tls"
    namespace = kubernetes_namespace_v1.kubernetes_namespaces[each.key].metadata[0].name
  }

  data = {
    "tls.crt" = tls_locally_signed_cert.tls_cert.cert_pem
    "tls.key" = tls_private_key.tls_cert_private_key.private_key_pem
  }
}
