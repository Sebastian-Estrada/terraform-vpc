terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-sebastian-2"
    key            = "vpc/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
