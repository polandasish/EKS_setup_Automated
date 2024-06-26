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

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false
    
  
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
   enable_cluster_creator_admin_permissions = true
  
   access_entries = {
    # One access entry with a policy associated
    my-eks-cluster = {
      kubernetes_groups = []
      #principal_arn     = "arn:aws:iam::090140969397:role/EC2-ROLE-EKS-CLUSTER"
      principal_arn       = "arn:aws:iam::090140969397:root"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      },
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::090140969397:role/EC2-ROLE-EKS-CLUSTER"

      policy_associations = {
        examle2 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }
  
 
  tags = {
    Environment = "dev"
    Terraform   = "true"
    Name= "eks"
  }
}



