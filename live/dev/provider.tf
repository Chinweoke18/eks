provider "aws" {
  region = local.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }

  }

  required_version = ">= 1.0"
}

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_name

  depends_on = [ module.eks ]
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name

  depends_on = [ module.eks ]
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint   #data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data) #data.aws_eks_cluster.default.certificate_authority[0].data
  # token                  = data.aws_eks_cluster_auth.default.token

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id] #data.aws_eks_cluster.default.id
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint                
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data) 
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id] 
      command     = "aws"
    }
  }
}