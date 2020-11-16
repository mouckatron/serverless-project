resource "aws_cognito_user_pool" "frontend" {
  name = local.domain

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  password_policy {
    minimum_length                   = 16
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  device_configuration {
    challenge_required_on_new_device      = false
    device_only_remembered_on_user_prompt = true
  }

  tags = {
    appname = var.appname
  }
}

resource "aws_cognito_user_pool_client" "frontend" {
  name         = var.appname
  user_pool_id = aws_cognito_user_pool.frontend.id
}

data "template_file" "cognito_frontend" {
  template = file("${path.module}/frontend-authentication-output-template.ts")
  vars = {
    region    = data.aws_region.current.name
    pool_id   = aws_cognito_user_pool.frontend.id
    client_id = aws_cognito_user_pool_client.frontend.id
  }
}

output "cognito_frontend" {
  value = data.template_file.cognito_frontend.rendered
}
