data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                   = local.name
  cidr                   = local.cidr
  azs                    = local.azs
  private_subnets        = local.private_subnets
  public_subnets         = local.public_subnets
  enable_nat_gateway     = local.enable_nat_gateway
  single_nat_gateway     = local.single_nat_gateway
  one_nat_gateway_per_az = local.one_nat_gateway_per_az
  enable_dns_hostnames   = local.enable_dns_hostnames
  enable_dns_support     = local.enable_dns_support
  public_subnet_tags     = local.public_subnet_tags
  private_subnet_tags    = local.private_subnet_tags

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                    = local.name
  cluster_version                 = local.cluster_version
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  eks_managed_node_groups         = local.eks_managed_node_groups
  tags                            = local.tags
  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  depends_on = [ module.vpc ]
}

module "alb-controller" {
  source = "../../modules/01-alb-controller"

  providers  = {
    helm = helm
  }

  cluster_name           = local.name
  app_name               = local.app_name
  cluster_id             = module.eks.cluster_name
  provider_arn           = module.eks.oidc_provider_arn

  depends_on = [ module.eks ]

}

module "external-dns" {
  source = "../../modules/02-external-dns"

  providers  = {
    helm = helm
  }

  cluster_name           = local.name
  app_name               = local.app_name
  cluster_id             = module.eks.cluster_name
  provider_arn           = module.eks.oidc_provider_arn
  domain_filters = local.domain_filters
  txt_owner_id = local.txt_owner_id

  depends_on = [ module.eks ]
}

module "iam" {
  source = "../../modules/04-iam"

  cluster_name      = local.name
  app_name          = local.app_name
  group_users       = local.group_users
  trusted_role_arns = module.vpc.vpc_owner_id
   
  depends_on = [ module.eks ]
}