terraform {
  backend "s3" {
    bucket         = "terraform-neto-bucket"
    encrypt        = false
    key            = "main-infra/terraform.tfstate"
    region         = "eu-north-1"
   # dynamodb_table = "terraform-locks"
  }
}
