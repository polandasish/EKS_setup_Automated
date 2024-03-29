variable "region" {
  default = "us-east-1"
}

variable "eksvpc_cidr" {
  description= "cluster vpc cidr"  
  type=string
}

variable "ekspub-subnet" {
    description= "Public Subnet cidr"
  type=list(string)
}

variable "ekspriv-subnet" {
    description= "Private Subnet cidr"
  type=list(string)
}

variable "instance_types" {
    description= "Node Instances"
  type= list(string)
}