
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

