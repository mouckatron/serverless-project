data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_route53_zone" "root_domain" {
  name = "${local.root_domain}."
}
