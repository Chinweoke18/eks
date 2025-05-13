locals {
    region = "us-east-1"

  # VPC Details
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnets = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/testdev" = "shared"
    "kubernetes.io/role/elb"    = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/testdev"       = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }

  # EKS Cluster Details
  name            = "testdev"
  cluster_version = "1.31"
  cidr            = "10.10.0.0/16"
  # eks_managed_node_group_defaults = {
  #   disk_size = 30
  # }
  eks_managed_node_groups = {
    node-group-1 = {
      desired_size = 1
      min_size     = 1
      max_size     = 1

      labels = {
        role = "node-group-1"
      }

      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
    }

    node-group-2 = {
      desired_size = 1
      min_size     = 1
      max_size     = 1

      labels = {
        role = "node-group-2"
      }

      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"

    }

  }
  tags = {
    Environment = "testdev"
  }

  app_name    = "lessons"
  group_users = ["user01@example.com","user02@example.com"]

  domain_filters = ["abc.com"]
  txt_owner_id = "fill in"

}