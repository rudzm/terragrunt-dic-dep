variable "project_name" {
  description = "GCP Project name"
  type        = string
}

variable "org_id" {
  description = "GCP organization id"
  type        = string
}

variable "folder_id" {
  description = "If set, org_id varaible is not used, because organization is taken from folder metadata"
  type        = string
  default     = ""
}

variable "billing_account" {
  description = "GCP billing account"
  type        = string
}

variable "svpc_host_project" {
  description = "Shared VPC host project"
  type        = string
}

variable "metrics_scope_project" {
  description = "Metrics scope project"
  type        = string
}
