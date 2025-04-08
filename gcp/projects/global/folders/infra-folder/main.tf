locals {
  parent = format("organizations/%s", var.org_id)
}

resource "google_folder" "folder" {
  display_name = var.folder_name
  parent       = local.parent
}

module "folder_iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4.0"

  mode     = "additive" # IAM member
  folders  = [resource.google_folder.folder.name]
  bindings = transpose(var.usr_to_roles)
}
