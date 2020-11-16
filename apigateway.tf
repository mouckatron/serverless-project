# resource "aws_apigatewayv2_api" "main" {
#   name          = local.appname
#   protocol_type = "HTTP"

#   tags = {
#     appname = local.appname
#   }
# }

# resource "aws_apigatewayv2_integration" "order" {
#   api_id           = aws_apigatewayv2_api.main.id
#   integration_type = "AWS"

#   connection_type           = "INTERNET"
#   content_handling_strategy = "CONVERT_TO_TEXT"
#   description               = "Lambda order"
#   integration_method        = "ANY"
#   integration_uri           = module.lambda_order.invoke_arn
# }
