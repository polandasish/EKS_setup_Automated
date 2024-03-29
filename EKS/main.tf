#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc"
  cidr = var.eksvpc_cidr

  azs                     = data.aws_availability_zones.azs.names
  public_subnets          = var.ekspub-subnet
  private_subnets         = var.ekspriv-subnet
  
  enable_dns_hostnames    = true
  enable_nat_gateway      = true
  single_nat_gateway      = true
  

  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb"               = 1

  }
  private_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/private_elb"       = 1

  }
  
}

locals {
  cluster_name="my-eks-cluster"
}


#EKS

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true
  
  
  
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  
   
  eks_managed_node_groups = {
    eksnodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = var.instance_types
            
    }
    
  }
 
  tags = {
    Environment = "dev"
    Terraform   = "true"
    Name= "eks"
  }
}

data "aws_eks_cluster" "cluster" {
  name=module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name=module.eks.cluster_id
}