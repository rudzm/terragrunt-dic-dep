
resource "google_logging_project_bucket_config" "bucket" {
  for_each = var.buckets

  project        = var.project_id
  location       = each.value.location
  bucket_id      = each.key
  retention_days = each.value.retention_days
  description    = each.value.description
}

locals {
  views_flat = merge([
    for bucket_name, cfg in var.buckets :
    { for v in try(cfg.views, []) :
      "${bucket_name}/${v.name}" => merge(v, {
        bucket_name = bucket_name,
        location    = cfg.location
      })
    }
  ]...)
}

resource "google_logging_log_view" "view" {
  for_each = local.views_flat

  name        = each.value.name
  bucket      = google_logging_project_bucket_config.bucket[each.value.bucket_name].id
  filter      = each.value.filter
  description = each.value.description
}

locals {
  iam_flat = merge([
    for bucket_name, cfg in var.buckets :
    { for b in try(cfg.view_iam_bindings, []) :
      "${bucket_name}/${b.view_name}/${b.role}" => merge(b, {
        bucket_name = bucket_name,
        view_name   = b.view_name,
        location    = cfg.location
      })
    }
  ]...)
}

resource "google_logging_log_view_iam_binding" "binding" {
  for_each = local.iam_flat

  name     = google_logging_log_view.view["${each.value.bucket_name}/${each.value.view_name}"].name
  parent   = google_logging_log_view.view["${each.value.bucket_name}/${each.value.view_name}"].parent
  bucket   = google_logging_log_view.view["${each.value.bucket_name}/${each.value.view_name}"].bucket
  location = each.value.location
  role     = each.value.role
  members  = each.value.members

  depends_on = [google_logging_log_view.view]
}
