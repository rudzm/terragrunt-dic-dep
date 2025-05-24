resource "google_logging_project_sink" "log_sink" {
  count       = var.sink_type == "project" ? 1 : 0
  name        = var.name
  project     = var.project_id
  destination = var.destination
  filter      = var.filter
  unique_writer_identity = true
  depends_on = [var.bucket_depends_on]

  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      name        = exclusions.value.name
      filter      = exclusions.value.filter
      description = exclusions.value.description
      disabled    = exclusions.value.disabled
    }
  }
}

resource "google_logging_folder_sink" "log_sink" {
  count       = var.sink_type == "folder" ? 1 : 0
  name        = var.name
  folder      = var.folder_id
  destination = var.destination
  filter      = var.filter
  unique_writer_identity = true
  depends_on = [var.bucket_depends_on]

  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      name        = exclusions.value.name
      filter      = exclusions.value.filter
      description = exclusions.value.description
      disabled    = exclusions.value.disabled
    }
  }
}

resource "google_logging_organization_sink" "log_sink" {
  count       = var.sink_type == "organization" ? 1 : 0
  name        = var.name
  org_id      = var.org_id
  destination = var.destination
  filter      = var.filter
  unique_writer_identity = true
  depends_on = [var.bucket_depends_on]

  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      name        = exclusions.value.name
      filter      = exclusions.value.filter
      description = exclusions.value.description
      disabled    = exclusions.value.disabled
    }
  }
}