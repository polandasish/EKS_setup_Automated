terraform {
  backend "s3" {
    bucket = "mywishbucket021"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"

  }
}