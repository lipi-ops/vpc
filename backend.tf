terraform {
  backend "s3" {
    bucket         = "terraform-lipi-test"
    key            = "mydoc/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

