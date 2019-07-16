variable "create_this_distribution" {
  default = true
}

variable "region" {}

variable "tier" {}

variable "organization" {
  default = ""
}

variable "extra_tags" {
  default = {}
}

variable "extra_tags_cloudfront" {
  default = {}
}

variable "enabled" {
  default = true
}

variable "aliases" {
  description = "Define name site, example wwww.site.com"
  type        = "list"
}

variable "default_root_object" {
  default = "index.html"
}

variable "ipv6_enabled" {
  default = false
}

variable "http_version" {
  default = "http2"
}

variable "price_class" {
  description = "(Optional) - The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  default     = "PriceClass_100"
}

variable "web_acl_id" {
  description = " (Optional) - If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned."
  default     = ""
}

variable "retain_on_delete" {
  description = "(Optional) - Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. Default: false."
  default     = true
}

variable "custom_error_response" {
  default = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    },
    {
      error_code = 403
      response_code = 200
      response_page_path = "/index.html"
    }
  ]
}

variable "wait_for_deployment" {
  default = false
}

variable "certificate_deafault_cloudfront" {
  default = true
}

variable "acm_certificate_arn" {
  default = ""
}

variable "minimum_protocol_version" {
  default = "TLSv1.2_2018"
}

variable "bucket_acl" {
  description = "Default is private, public-read if use website"
  default     = "private"
}

variable "website" {
  default = {
    index_document = null
    error_document = null
  }
}