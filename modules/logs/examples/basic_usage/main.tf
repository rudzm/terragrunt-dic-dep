module "log_bucket" {
  source         = "../../modules/log_bucket"
  project_id     = "my-project"
  name           = "app-logs"
  location       = "global"
  retention_days = 30
  labels = {
    env  = "prod"
    team = "devops"
  }
}

module "log_bucket_app" {
  source         = "../../modules/log_bucket"
  project_id     = "my-project"
  name           = "app-logs"
  location       = "global"
  retention_days = 30

  views = [
    {
      name        = "error-view"
      filter      = "severity>=ERROR"
      description = "Widok dla errorów"
    },
    {
      name        = "gce-view"
      filter      = "resource.type=gce_instance"
      description = "Widok dla GCE"
    }
  ]

  # IAM bindings do widoków
  view_iam_bindings = [
    {
      view_name = "error-view"
      role      = "roles/logging.viewAccessor"
      members   = [
        "user:devops@example.com",
        "serviceAccount:analytics@my-project.iam.gserviceaccount.com"
      ]
    },
    {
      view_name = "gce-view"
      role      = "roles/logging.viewAccessor"
      members   = [
        "group:platform-team@example.com"
      ]
    }
  ]
}

module "project_sink" {
  source            = "../../modules/log_sink"
  project_id        = "my-project"
  name              = "app-sink"
  bucket_id         = module.log_bucket_app.bucket_id
  bucket_location   = "global"
  filter            = "resource.type=gce_instance AND labels.team=\"devops\""
  bucket_depends_on = [module.log_bucket_app]
}


module "folder_sink" {
  source          = "../../modules/log_sink"
  sink_type       = "folder"
  folder_id       = "folders/9876543210"
  name            = "folder-sink"
  destination     = "logging.googleapis.com/projects/my-logging-project/locations/global/buckets/folder-logs"
  filter          = "resource.type=\"cloud_run_revision\""

  exclusions = [
    {
      name        = "exclude-info"
      filter      = "severity=INFO"
      description = "Exclude info logs"
      disabled    = false
    }
  ]
}

module "org_sink" {
  source      = "../../modules/log_sink"
  sink_type   = "organization"
  org_id      = "1234567890"
  name        = "org-sink"
  destination = "logging.googleapis.com/projects/my-project/locations/global/buckets/org-logs"
  filter      = "severity>=ERROR"

  exclusions = [
    {
      name        = "exclude-debug"
      filter      = "severity=DEBUG"
      description = "Exclude debug logs"
      disabled    = false
    }
  ]
}
