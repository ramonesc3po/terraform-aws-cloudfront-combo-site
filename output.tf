locals {
  len_aliases = length(var.aliases)
}

output "domain_name" {
  value = element(aws_cloudfront_distribution.this.*.domain_name, local.len_aliases)
}

output "hosted_zone_id" {
  value = element(aws_cloudfront_distribution.this.*.hosted_zone_id, local.len_aliases)
}

output "bucket_id" {
  value = element(aws_s3_bucket.this.*.id, 0)
}
