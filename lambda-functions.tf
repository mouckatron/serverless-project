
resource "aws_lambda_function" "lambda" {
  count = var.lambda_functions

  function_name = "${var.appname}-${var.lambda_functions[count.index].name}"

  s3_bucket = aws_s3_bucket.lambda.id
  s3_key    = "${var.lambda_functions[count.index].name}.zip"

  handler = var.lambda_functions[count.index].name
  runtime = var.lambda_functions[count.index].runtime

  role = aws_iam_role.lambda.arn

  tags = {
    appname = var.appname
  }
}
