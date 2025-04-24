# https://registry.terraform.io/modules/terraform-google-modules/cloud-storage/google/latest

module "multi_buckets" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "~> 10.0"
  project_id = var.project_id

  names  = ["dev-logs", "prod-data", "temp-storage"]
  prefix = "myapp"

  versioning = {
    "dev-logs"   = true
    "prod-data"  = true
    "temp-storage" = false
  }

  bucket_lifecycle_rules = {
    "temp-storage" = [
      {
        action = {
          type = "Delete"
        }
        condition = {
          age = 2
        }
      }
    ]
  }

  bucket_admins = {
    "prod-data" = "user:admin@example.com"
  }

  public_access_prevention = {
    "dev-logs"   = "enforced"
    "prod-data"  = "enforced"
    "temp-storage" = "enforced"
  }

}

module "versioned_retention_bucket" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "~> 10.0"
  project_id = var.project_id

  names = ["backup-bucket"]
  prefix = "infra"

  versioning = {
    "backup-bucket" = true
  }

  retention_policy = {
    "backup-bucket" = {
      retention_period = 2592000  # 30 dni
      is_locked        = false
    }
  }
}

module "lifecycle_bucket" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "~> 10.0"
  project_id = var.project_id

  names = ["logs-bucket"]
  prefix = "app"

  bucket_lifecycle_rules = {
    "logs-bucket" = [
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
}
