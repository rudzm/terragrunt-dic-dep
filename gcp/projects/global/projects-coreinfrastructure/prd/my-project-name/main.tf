# Create empty project, remove default privileged service account and create new one with no privileges. Enable required APIs.
# docs: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google/latest
module "project_factory" {
  source  = "terraform-google-modules/project-factory/google//modules/svpc_service_project"
  version = "~> 13.1.0"

  name                               = var.project_name
  random_project_id                  = true
  folder_id                          = var.folder_id
  org_id                             = var.org_id
  billing_account                    = var.billing_account
  default_service_account            = "delete"
  shared_vpc                         = var.svpc_host_project
  grant_services_security_admin_role = true
  activate_apis = [
    "analyticsadmin.googleapis.com",
    "analyticsdata.googleapis.com",
    "analyticsreporting.googleapis.com",
    "cloudscheduler.googleapis.com",
    "container.googleapis.com",
    "redis.googleapis.com",
    "servicenetworking.googleapis.com",
    "secretmanager.googleapis.com",
    "sqladmin.googleapis.com",
    "workflows.googleapis.com"
  ]
}

