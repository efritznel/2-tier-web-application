resource "aws_wafv2_web_acl" "my_web_acl" {
  name        = var.name
  description = var.description
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.metric_name
    sampled_requests_enabled   = true
  }

  ############################
  # AWS Managed Rules
  ############################
  rule {
    name     = "AWSManagedCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSCommonRules"
      sampled_requests_enabled   = true
    }
  }

  ############################
  # Rate Limiting
  ############################
  dynamic "rule" {
    for_each = var.enable_rate_limit ? [1] : []

    content {
      name     = "RateLimitRule"
      priority = 2

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = var.rate_limit
          aggregate_key_type = "IP"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "RateLimit"
        sampled_requests_enabled   = true
      }
    }
  }

  ############################
  # IP Allow / Deny
  ############################
  dynamic "rule" {
    for_each = length(var.ip_set_arn) > 0 ? [1] : []

    content {
      name     = "IPRestrictionRule"
      priority = 3

      action {
        block {}
      }

      statement {
        not_statement {
          statement {
            ip_set_reference_statement {
              arn = var.ip_set_arn
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "IPRestriction"
        sampled_requests_enabled   = true
      }
    }
  }
}
