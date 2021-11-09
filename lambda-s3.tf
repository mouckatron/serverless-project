
resource "aws_s3_bucket" "lambda" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.appname}-lambdas"
  acl    = "private"
  tags = {
    appname = var.appname
  }
}

output "aws_s3_bucket_lambda_name" {
  value = aws_s3_bucket.lambda.id
}
