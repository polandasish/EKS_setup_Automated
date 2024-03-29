resource "aws_security_group" "eks-sg" {
    name = "EKS-Securitygroup"
    description = "Security group for EKS Cluster"
    vpc_id = module.vpc.vpc_id 
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
  from_port = 3000
  to_port = 10000
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
ingress {
  from_port = 30000
  to_port = 32767
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
  
}