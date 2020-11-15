
resource "aws_s3_bucket" "lambda" {
  bucket = "${var.appname}-lambdas"
  acl    = "private"
  tags = {
    appname = var.appname
  }
}
