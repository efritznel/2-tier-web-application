resource "aws_route53_zone" "public" {
  name = var.hosted_zone_name
}

resource "aws_route53_record" "cloudfront_record" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "week3.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}


