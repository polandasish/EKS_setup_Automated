variable "region" {
  default = "us-west-1"
}
variable "vpc_cidr" {
  type = string

}

variable "mypublic-subnet" {
  type = list(string)

}

variable "instance_type" {
  type = string
}
variable "rolename" {
  type = string
}
