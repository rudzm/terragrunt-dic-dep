locals {
  # Use directory name as a folder_name to keep naming consistent
  folder_name = "${basename(get_terragrunt_dir())}"

  usr_to_roles = {
    "user:user@example.com" = [
      "roles/storage.objectCreator",
      "roles/storage.objectViewer",
      "roles/secretmanager.admin",
      "roles/cloudsql.client",
      "roles/cloudsql.instanceUser"
    ]
    "user:user2@example.com" = [
      "roles/logging.viewer"
    ]
    
  }
}