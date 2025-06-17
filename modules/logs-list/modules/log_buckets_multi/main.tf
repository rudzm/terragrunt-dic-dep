resource "google_logging_project_bucket_config" "bucket" {
  for_each      = var.buckets

  project        = var.project_id
  location       = each.value.location
  bucket_id      = each.key
  retention_days = each.value.retention_days
  description    = each.value.description
}

locals {
  views_flat = merge([
    for bucket_name, cfg in var.buckets :
    { for v in cfg.views :
        "${bucket_name}/${v.name}" => merge(v, { bucket_name = bucket_name, location = cfg.location })
    }
  ]...)
}

resource "google_logging_project_bucket_config_view" "view" {
  for_each = local.views_flat

  project     = var.project_id
  location    = each.value.location
  bucket      = each.value.bucket_name
  view_id     = each.value.name
  filter      = each.value.filter
  description = each.value.description
}

locals {
  iam_flat = merge([
    for bucket_name, cfg in var.buckets :
    { for b in cfg.view_iam_bindings :
        "${bucket_name}/${b.view_name}/${b.role}" => merge(b, {
          bucket_name = bucket_name,
          location    = cfg.location
        })
    }
  ]...)
}

resource "google_logging_view_iam_binding" "binding" {
  for_each = local.iam_flat

  project  = var.project_id
  location = each.value.location
  bucket   = each.value.bucket_name
  view     = each.value.view_name
  role     = each.value.role
  members  = each.value.members

  depends_on = [google_logging_project_bucket_config_view.view]
}