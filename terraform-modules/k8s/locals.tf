locals {
  tls_cert_subject_name = "*.${var.top_level_domain}"
  tls_cert_dns_names    = [var.top_level_domain, local.tls_cert_subject_name]
  tls_cert_uris         = [for host in local.tls_cert_dns_names : "https://${host}"]

  sample_namespace = tolist(var.kubernetes_namespaces)[0]

  # https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
  ingress_controller_values = {
    controller = {
      service = {
        # These annotations will provision a load balancer for us
        # https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingloadbalancer.htm#contengcreatingloadbalancer_topic_Summaryofannotations
        annotations = {
          "oci.oraclecloud.com/load-balancer-type"                      = "lb"
          "service.beta.kubernetes.io/oci-load-balancer-shape"          = "flexible"
          "service.beta.kubernetes.io/oci-load-balancer-shape-flex-min" = "10"
          "service.beta.kubernetes.io/oci-load-balancer-shape-flex-max" = "10"
          "service.beta.kubernetes.io/oci-load-balancer-internal"       = "false"
          "service.beta.kubernetes.io/oci-load-balancer-subnet1"        = data.terraform_remote_state.oke.outputs.k8s_services_subnet_id
        }
      }
    }
  }
}
