terraform {
  backend "s3" {
    bucket         = "ivolve-state-bucket"
    key            = "terraform/state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
