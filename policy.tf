data "aws_iam_policy_document" "s3_bucket_site" {
  statement {
    sid       = "${var.tier}AllowAccessCloudfront"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
      type        = "AWS"
    }
  }

  statement {
    sid       = "${var.tier}AllowAccessCloudFront2"
    actions   = ["s3:ListBucket"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.this.arn}"]

    principals {
      identifiers = ["${aws_cloudfront_origin_access_identity.this.iam_arn}"]
      type        = "AWS"
    }
  }
}

data "aws_iam_policy_document" "s3_website_bucket_site" {
  statement {
    sid       = "${var.tier}AllowAccessPublicWebsite"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }

  statement {
    sid       = "${var.tier}AllowAccessPublicWebsite2"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.this.arn}"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}