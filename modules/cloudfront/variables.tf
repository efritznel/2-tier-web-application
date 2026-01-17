variable "certificate_domain_name"{}
variable "alb_domain_name" {}
variable "additional_domain_name" {}
variable "project_name" {}

variable "web_acl_arn" {
  description = "WAFv2 Web ACL ARN to associate with CloudFront (optional)."
  type        = string
  default     = null
}
