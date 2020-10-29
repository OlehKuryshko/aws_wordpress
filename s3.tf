resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.bucket_name}"
  acl    = "private"
  tags = {
    owner = var.owner
  }
}