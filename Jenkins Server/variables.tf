variable "region" {
  default = "us-east-1"
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