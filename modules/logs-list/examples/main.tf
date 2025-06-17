module "log_buckets" {
  source     = "../modules/log_buckets_multi"
  project_id = "logs-project"

  buckets = {
    "app-logs" = {
      location       = "global"
      retention_days = 30
      description    = "Application logs"
      views = [
        {
          name        = "errors"
          filter      = "severity>=ERROR"
          description = "Errors only"
        },
        {
          name        = "gce"
          filter      = "resource.type=gce_instance"
          description = "GCE logs"
        }
      ]
      view_iam_bindings = [
        {
          view_name = "errors"
          role      = "roles/logging.viewAccessor"
          members   = ["user:ops@example.com"]
        }
      ]
    }

    "audit-logs" = {
      location       = "global"
      retention_days = 365
      description    = "Audit logs"
    }
  }
}

module "log_sinks" {
  source     = "../modules/log_sinks_multi"
  project_id = "workloads-project"

  sinks = {
    app_error_sink = {
      sink_type   = "project"
      project_id  = "workloads-project"
      destination = "logging.googleapis.com/projects/logs-project/locations/global/buckets/app-logs"
      filter      = "severity>=ERROR"
    }

    org_audit_sink = {
      sink_type   = "organization"
      org_id      = "1234567890"
      destination = "logging.googleapis.com/projects/logs-project/locations/global/buckets/audit-logs"
      filter      = ""
      exclusions  = [
        {
          name        = "skip-debug"
          filter      = "severity=DEBUG"
          description = "Omit debug logs"
          disabled    = false
        }
      ]
    }
  }
}