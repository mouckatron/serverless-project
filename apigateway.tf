resource "aws_api_gateway_rest_api" "main" {
  name = "${var.appname}-backend"
  tags = {
    appname = var.appname
  }
}

resource "aws_api_gateway_stage" "production" {
  stage_name  = "production"
  rest_api_id = aws_api_gateway_rest_api.main.id
  tags = {
    appname = var.appname
  }
}

resource "aws_api_gateway_stage" "beta" {
  stage_name = "beta"
  tags = {
    appname = var.appname
  }
}

resource "aws_api_gateway_resource" "lambdas" {
  count = length(var.lambda_functions)

  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.root_resource_id

  path_part = var.lambda_functions[count.index].name

  tags = {
    appname = var.appname
  }
}

resource "aws_api_gateway_authorizer" "main" {
  name          = "${var.appname}-cognito-authorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.main.id
  provider_arns = aws_cognito_user_pool.frontend.arn

  tags = {
    appname = var.appname
  }
}

resource "aws_api_gateway_method" "any" {
  count = length(var.lambda_functions)

  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.lambdas[count.index].id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.main.id

  request_parameters = {
    "method.request.path.proxy" = true
  }

  tags = {
    appname = var.appname
  }
}
