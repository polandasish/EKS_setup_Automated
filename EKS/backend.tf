terraform {
  backend "s3" {
    bucket = "mywishbucket021"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"

  }
}