resource "aws_iam_role" "lambda" {
  name_prefix = var.appname

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

output "aws_iam_role_lambda_arn" {
  value = aws_iam_role.lambda.arn
}

output "aws_iam_role_lambda_id" {
  value = aws_iam_role.lambda.id
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  role       = aws_iam_role.lambda.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
