
resource "aws_lambda_function" "lambda" {
  for_each = toset(var.lambda_functions)

  function_name = "${var.appname}-${each.value.name}"

  s3_bucket = aws_s3_bucket.backend.id
  s3_key    = "${each.value.name}.zip"

  handler = each.value.name
  runtime = each.value.runtime

  role = aws_iam_role.lambda.arn

  tags = {
    appname = var.appname
  }
}
