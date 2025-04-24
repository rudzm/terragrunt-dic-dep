module "group" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.7"

  id           = "example-group@example.com"
  display_name = "example-group"
  description  = "Example group"
  domain       = "example.com"
  owners       = ["foo@example.com"]
  managers     = ["example-sa@my-project.iam.gserviceaccount.com"]
  members      = ["another-group@example.com"]
}