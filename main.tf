locals {
  common_tags = {
    Tier         = var.tier
    Region       = var.region
    Organization = var.organization
  }

  common_tags_cloudfront = {
    Bucket = aws_s3_bucket.this.id
  }

  bucket_name_with_cloudfront = "${var.aliases[0]}-${var.region}-${var.tier}"
  bucket_name_website = "${var.aliases[0]}"

  compose_name_bucket = var.website["index_document"] != null ? local.bucket_name_website : local.bucket_name_with_cloudfront
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = var.website["index_document"] == null ? data.aws_iam_policy_document.s3_bucket_site.json : data.aws_iam_policy_document.s3_website_bucket_site.json
}

resource "aws_s3_bucket" "this" {
  bucket = local.compose_name_bucket
  region = var.region
#  website {
#    index_document = var.website["index_document"] != null ? var.website["index_document"] : ""
#    error_document = var.website["error_document"] != null ? var.website["error_document"] : ""
#  }

  acl = var.bucket_acl

  tags = merge(local.common_tags, var.extra_tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${var.aliases[0]}-${var.region}"
}

resource "aws_cloudfront_distribution" "this" {
  count               = var.create_this_distribution == true ? 1 : 0
  enabled             = var.enabled
  comment             = var.aliases[0]
  aliases             = var.certificate_deafault_cloudfront == false ? var.aliases : null
  default_root_object = var.default_root_object
  is_ipv6_enabled     = var.ipv6_enabled
  http_version        = var.http_version
  price_class         = var.price_class
  web_acl_id          = var.web_acl_id
  retain_on_delete    = var.retain_on_delete

  wait_for_deployment = var.wait_for_deployment

  dynamic "custom_error_response" {
    for_each = [for custom_errors in var.custom_error_response: {
      error_code = custom_errors.error_code
      response_code = custom_errors.response_code
      response_page_path = custom_errors.response_page_path
    }]
    content {
      error_code = custom_error_response.value.error_code
      response_code = custom_error_response.value.response_code
      response_page_path = custom_error_response.value.response_page_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  // Ever will be create.

  origin {
    domain_name = "${aws_s3_bucket.this.bucket_regional_domain_name}"
    origin_id   = "${aws_s3_bucket.this.id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${aws_s3_bucket.this.id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.certificate_deafault_cloudfront == true ? true : false
    acm_certificate_arn            = var.acm_certificate_arn != "" ? var.acm_certificate_arn : null
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = var.acm_certificate_arn != "" ? var.minimum_protocol_version : "TLSv1"
  }

  tags = merge(local.common_tags, var.extra_tags_cloudfront, var.extra_tags, local.common_tags_cloudfront)
}