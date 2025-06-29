
provider "google" {
  project = "m-sandbox"
  region  = "europe-central2"
}

module "log_buckets" {
  source     = "../modules/log_buckets_multi"
  project_id = "m-sandbox"

  buckets = {
    "app-logs" = {
      location       = "global"
      retention_days = 30
      description    = "App logs"
      views = [
        {
          name        = "errors"
          filter      = "resource.type = \"k8s_container\""
          description = "Only GKE container logs"
        },
        {
          name        = "errors2"
          filter      = "resource.type = \"k8s_container\""
          description = "Only GKE container logs"
        }
      ]
      view_iam_bindings = [
        {
          view_name = "errors"
          role      = "roles/logging.viewAccessor"
          members   = ["user:m.rudz@text.com"]
        },
        {
          view_name = "errors2"
          role      = "roles/logging.viewAccessor"
          members   = ["user:m.rudz@text.com"]
        }
      ]
    }
  }
}


module "log_sinks" {
  source     = "../modules/log_sinks_multi"
  project_id = "m-sandbox"

  sinks = {
    app_error_sink = {
      sink_type   = "project"
      project_id  = "m-sandbox"
      destination = "logging.googleapis.com/projects/m-sandbox/locations/global/buckets/app-logs"
      filter      = "resource.type = \"k8s_container\""
    }
  }
}