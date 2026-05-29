terraform {
  backend "s3" {
    bucket         = "petclinic-terraform-state-athul-100"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "petclinic-terraform-locks"
    encrypt        = true
  }
}