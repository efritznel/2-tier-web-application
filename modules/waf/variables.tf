variable "name" {
  description = "WAF Web ACL name"
  type        = string
}

variable "description" {
  description = "WAF description"
  type        = string
  default     = "WAF for CloudFront distribution"
}

variable "metric_name" {
  description = "CloudWatch metric name"
  type        = string
}

variable "enable_rate_limit" {
  description = "Enable rate limiting rule"
  type        = bool
  default     = true
}

variable "rate_limit" {
  description = "Requests per 5-minute period per IP"
  type        = number
  default     = 2000
}

variable "ip_set_arn" {
  description = "Optional IP set ARN for allow-listing"
  type        = string
  default     = ""
}
