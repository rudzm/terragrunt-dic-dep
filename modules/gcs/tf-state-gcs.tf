module "tf_state_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 4.0"

  name          = "my-terraform-state-bucket"
  project_id    = var.project_id
  location      = "EU"
  versioning    = true
  # Zabezpieczenie przed usunięciem bucketu póki są w nim obiekty
  force_destroy = false
  # Wymusza brak publicznego dostępu do bucketu 
  public_access_prevention = "enforced"

  lifecycle_rules = [
    {
      action = { type = "Delete" }
      condition = {
        #będzie usuwać stare wersje obiektów po 90 dniach
        days_since_noncurrent_time = 90
        #będzie trzymać maksymalnie 7 wersje obiektów
        num_newer_versions          = 7
      }
    }
  ]
  
  iam_members = [
    {
      role   = "roles/storage.admin"
      member = "group:terraform-admins@mydomain.com"
    },
    {
      role   = "roles/storage.objectViewer"
      member = "group:terraform-readers@mydomain.com"
    }
  ]

  labels = {
    environment = "prod"
    team        = "infra"
    purpose     = "terraform-state"
  }
}