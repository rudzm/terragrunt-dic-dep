
# https://registry.terraform.io/modules/terraform-google-modules/cloud-storage/google/latest/submodules/simple_bucket

module "private_bucket" {
  source     = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version    = "~> 10.0"
  project_id = var.project_id

  name       = "my-private-bucket"
  location   = "EU"

  public_access_prevention    = "enforced"
}

module "versioned_bucket" {
  source     = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version    = "~> 10.0"
  project_id = var.project_id

  name     = "my-versioned-bucket"
  location = "US"

  versioning = {
    enabled = true
  }

  retention_policy = {
    retention_period = 2592000  # 30 dni w sekundach
    is_locked        = false
  }
}

module "lifecycle_bucket" {
  source     = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version    = "~> 10.0"
  project_id = var.project_id

  name     = "my-lifecycle-bucket"
  location = "US"

  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age = 90
      }
    }
  ]
}

module "public_website_bucket" {
  source     = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version    = "~> 10.0"
  project_id = var.project_id

  name     = "my-website-bucket"
  location = "US"

  website = {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  iam_members = [
    "allUsers:roles/storage.objectViewer"
  ]

  public_access_prevention    = "inherited"
}
