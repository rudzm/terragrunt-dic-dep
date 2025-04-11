
locals {
  # only projects with billing account attached
  projects = [for p in data.google_project.description : p.project_id if p.billing_account == var.billing_account]

  project_and_meta = { for p in local.projects : p =>
    {
      notification_channels_email = concat(var.default_notification_channels_email,
      try(var.projects_billing_alerts[p].notification_channels_email, [])),
      budget = merge(var.default_budget,
      try(var.projects_billing_alerts[p].budget, {}))
  } }

  notification_channels_email = distinct(flatten([for p in keys(var.projects_billing_alerts) :
  var.projects_billing_alerts[p].notification_channels_email]))

  all_notification_channels_email = concat(var.default_notification_channels_email,
  local.notification_channels_email)
}

data "google_projects" "org_projects" {
  # see: https://cloud.google.com/asset-inventory/docs/query-syntax
  # "sys-*" gsuite automatic generated projects
  filter = "lifecycleState:ACTIVE lifecycleState:ACTIVE AND NOT id:sys-*"
}

data "google_project" "description" {
  for_each = { for p in data.google_projects.org_projects.projects[*].project_id : p => p }

  project_id = each.key
}


resource "google_organization_iam_custom_role" "custom_roles" {
  for_each = var.custom_roles

  role_id     = lower(each.key)
  org_id      = var.org_id
  title       = replace(each.key, "_", " ")
  description = each.value.description

  # for big roles use permissions_file
  permissions = each.value.permissions_file != null ? compact(split("\n", file(each.value.permissions_file))) : each.value.permissions
}

module "organization_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/organizations_iam"
  version = "~> 7.4.0"

  organizations = [var.org_id]
  mode          = "additive" # IAM member
  bindings      = transpose(var.usr_to_roles)

  depends_on = [google_organization_iam_custom_role.custom_roles]
}

# Create all notification channels
resource "google_monitoring_notification_channel" "email" {
  # Avoid duplicate channels definitions (unique combination of email & description)
  for_each = { for k in local.all_notification_channels_email : uuidv5("oid", join("", values(k))) => k }

  project      = "dummy"
  display_name = each.value.display_name
  type         = "email"
  labels = {
    email_address = each.value.email
  }
  force_delete = false
}

module "billing_budgets_and_alerting" {
  for_each = local.project_and_meta

  source  = "terraform-google-modules/project-factory/google//modules/budget"
  version = "~> 14.2.0"

  billing_account      = var.billing_account
  projects             = [each.key]
  amount               = each.value.budget.amount
  alert_spent_percents = each.value.budget.tresholds
  monitoring_notification_channels = flatten(
    [for e in local.project_and_meta[each.key].notification_channels_email :
  [for i, j in google_monitoring_notification_channel.email : j.name if i == uuidv5("oid", join("", values(e)))]])
}