
resource "aws_s3_bucket" "lambda" {
  bucket = "${var.appname}-lambdas"
  acl    = "private"
  tags = {
    appname = var.appname
  }
}

output "s3_bucket_lambda_id" {
  value = aws_s3_bucket.lambda.id
}

output "s3_bucket_lambda_arn" {
  value = aws_s3_bucket.lambda.arn
}
