# provider "helm" {
#   kubernetes {
#     host                   = var.host                   
#     cluster_ca_certificate = var.cluster_ca_certificate 
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", var.args] 
#       command     = "aws"
#     }
#   }
# }


terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
  }
}