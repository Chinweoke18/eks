module "external_dns_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = "${var.app_name}-${var.cluster_name}-external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/*"]

  oidc_providers = {
    ex = {
      provider_arn               = var.provider_arn
      namespace_service_accounts = ["kube-system:${var.app_name}-${var.cluster_name}-external-dns"]
    }
  }

}


resource "helm_release" "externalDNS" {
  name       = "${var.app_name}-${var.cluster_name}-external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = "6.15.0"
  set {
    name  = "txtOwnerId"
    value = var.txt_owner_id
  }

  set {
    name  = "rbac.create"
    value = true
  }

  set {
    name  = "provider"
    value = "aws"
  }
  # set {
  #   name  = "rbac.pspEnabled"
  #   value = false
  # }
  set {
    name  = "sources"
    value = "{ingress,service}"
  }
  set {
    name  = "serviceAccount.name"
    value = "${var.app_name}-${var.cluster_name}-external-dns"
  }
  set {
    name  = "domainFilters"
    value = "{${join(",", var.domain_filters)}}"
  }

  # set {
  #   name  = "policy"
  #   value = var.policy
  # }

  set {
    name  = "aws.zoneType"
    value = var.external_dns_zoneType
  }
  set {
    name  = "eks.amazonaws.com/role-arn"
    value = module.external_dns_irsa_role.iam_role_arn
  }
}