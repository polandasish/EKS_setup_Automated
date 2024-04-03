terraform {
  backend "s3" {
    bucket = "myjenkinsbucketwest1"
    key    = "local-jenkins/terraform.tfstate"
    region = "us-west-1"

  }
}
