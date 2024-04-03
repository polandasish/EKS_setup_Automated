module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.azs.names
  public_subnets          = var.mypublic-subnet
  map_public_ip_on_launch = true
  enable_dns_hostnames    = true

  tags = {
    Name        = "Jenkins-VPC"
    Terraform   = "true"
    Environment = "dev"

  }
  public_subnet_tags = {
    Name = "Jenkins-subnet-pub"
  }
}

#security-group
resource "aws_security_group" "jenkins-sg" {
  name   = "jenkins-sg"
  vpc_id = module.vpc.vpc_id
  dynamic "ingress" {
    for_each = local.inbound-rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Jenkins-sg"
  }
}

#Aws-key-pair
resource "aws_key_pair" "jenkins-key" {
  key_name   = "jkey"
  public_key = file("jkey.pem.pub")

}

#Ec2 Instance
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Jenkins-instance"

  instance_type               = var.instance_type
  key_name                    = aws_key_pair.jenkins-key.key_name
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  ami                         = data.aws_ami.ubuntu.id
  user_data                   = file("script.sh")
  associate_public_ip_address = true
  availability_zone           = data.aws_availability_zones.azs.names[0]
  iam_instance_profile        = data.aws_iam_instance_profile.existing-role.role_name

  tags = {
    Name        = "Jenkins_instance"
    Terraform   = "true"
    Environment = "dev"
  }
}


