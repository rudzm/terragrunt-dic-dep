resource "google_logging_project_bucket_config" "log_bucket" {
  project         = var.project_id
  location        = var.location
  retention_days  = var.retention_days
  bucket_id       = var.name
  description     = var.description
}

resource "google_logging_project_bucket_config_view" "log_bucket_view" {
  for_each = var.views == [] ? {} : { for v in var.views : v.name => v }

  project     = var.project_id
  location    = var.location
  bucket      = var.name
  view_id     = each.key
  filter      = each.value.filter
  description = each.value.description
}

resource "google_logging_view_iam_binding" "view_iam_binding" {
  for_each = var.view_iam_bindings == [] ? {} : {
    for b in var.view_iam_bindings : "${b.view_name}-${b.role}" => b
  }

  project  = var.project_id
  location = var.location
  bucket   = var.name
  view     = each.value.view_name
  role     = each.value.role
  members  = each.value.members

  depends_on = [google_logging_project_bucket_config_view.log_bucket_view]
}