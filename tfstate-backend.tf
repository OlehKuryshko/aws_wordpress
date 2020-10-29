terraform {
  backend "s3" {
    bucket         = "okury-terraformbackend"
    key            = "dev/task1/terraform.tfstate"
  }
}