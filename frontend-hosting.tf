
## S3 BUCKET
resource "aws_s3_bucket" "frontend" {
  bucket = local.domain
  acl    = "private"
  tags = {
    appname = var.appname
  }
}

data "template_file" "frontend_policy" {
  template = file("frontend-hosting-bucket-policy.json")
  vars = {
    s3_bucket          = aws_s3_bucket.frontend.id
    cloudfront_oai_arn = aws_cloudfront_origin_access_identity.frontend.iam_arn
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.template_file.frontend_policy.rendered
}

# CLOUDFRONT
resource "aws_cloudfront_origin_access_identity" "frontend" {
}

resource "aws_acm_certificate" "frontend" {
  provider          = aws.ue1
  domain_name       = local.domain
  validation_method = "DNS"

  tags = {
    appname = var.appname
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certvalidation" {
  for_each = {
    for dvo in aws_acm_certificate.frontend.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.root_domain.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  provider                = aws.ue1
  certificate_arn         = aws_acm_certificate.frontend.arn
  validation_record_fqdns = [for record in aws_route53_record.certvalidation : record.fqdn]
}

resource "aws_cloudfront_distribution" "frontend" {
  origin {
    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id   = local.domain

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "GB"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = local.domain

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.frontend.arn
    ssl_support_method  = "sni-only"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [local.domain]

  tags = {
    appname = var.appname
  }
}

resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.root_domain.zone_id
  name    = local.domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}
