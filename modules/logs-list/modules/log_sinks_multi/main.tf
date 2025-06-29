locals {
  by_type = {
    project      = { for k, v in var.sinks : k => v if v.sink_type == "project" }
    folder       = { for k, v in var.sinks : k => v if v.sink_type == "folder" }
    organization = { for k, v in var.sinks : k => v if v.sink_type == "organization" }
  }
}

resource "google_logging_project_sink" "project" {
  for_each               = local.by_type.project
  name                   = each.key
  project                = coalesce(each.value.project_id, var.project_id)
  destination            = each.value.destination
  filter                 = each.value.filter
  unique_writer_identity = try(each.value.unique_writer_identity, false)

  dynamic "exclusions" {
    for_each = each.value.exclusions
    content {
      name        = exclusions.value.name
      filter      = exclusions.value.filter
      description = exclusions.value.description
      disabled    = exclusions.value.disabled
    }
  }
}

resource "google_logging_folder_sink" "folder" {
  for_each    = local.by_type.folder
  name        = each.key
  folder      = each.value.folder_id
  destination = each.value.destination
  filter      = each.value.filter

  dynamic "exclusions" {
    for_each = each.value.exclusions
    content {
      name        = exclusions.value.name
      filter      = exclusions.value.filter
      description = exclusions.value.description
      disabled    = exclusions.value.disabled
    }
  }
}

resource "google_logging_organization_sink" "org" {
  for_each    = local.by_type.organization
  name        = each.key
  org_id      = each.value.org_id
  destination = each.value.destination
  filter      = each.value.filter

  dynamic "exclusions" {
    for_each = each.value.exclusions
    content {
      name        = exclusions.value.name
      filter      = exclusions.value.filter
      description = exclusions.value.description
      disabled    = exclusions.value.disabled
    }
  }
}