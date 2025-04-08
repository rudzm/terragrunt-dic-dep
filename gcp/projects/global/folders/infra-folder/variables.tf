variable "org_id" {
  description = "GCP organization id. Default taken from terragrunt setup"
  type        = string
}

variable "folder_name" {
  description = "GCP folder name. Default taken form terragrunt setup"
  type        = string
}

variable "usr_to_roles" {
  description = "map GCP IAM roles list to a user"
  type        = map(list(string))
}
