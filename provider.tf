provider "aws" {
  region     = var.region
  shared_credentials_file = var.key_aws
}
#-------------------- provider specifically for certificate validation
provider "aws" {
  region     = var.region
  alias = "account_route53" 
  version = ">= 3.4.0"
}
