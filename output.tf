locals {
  len_aliases = length(var.aliases)
}

output "domain_name" {
  value = element(concat(aws_cloudfront_distribution.this.*.domain_name, list("")), local.len_aliases)
}

output "hosted_zone_id" {
  value = element(concat(aws_cloudfront_distribution.this.*.hosted_zone_id, list("")), local.len_aliases)
}

output "bucket_id" {
  value = element(concat(aws_s3_bucket.this.*.id, list("")), 0)
}
