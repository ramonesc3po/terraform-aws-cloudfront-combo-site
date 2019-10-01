module "new_site" {
  source = "../" # source = "github.com/ramonesc3po/terraform-aws-cloudfront-combo-site.git?ref=develop"

  tier                            = "production"
  organization                    = "example"
  region                          = "us-east-1"
  aliases                         = ["new_site.com"] # even if you don't use cloudfront certificate put the alias.
  certificate_default_cloudfront = true
}
