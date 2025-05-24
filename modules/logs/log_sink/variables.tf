variable "sink_type" {
  type        = string
  default     = "project"
  description = "Sink level: project, folder, or organization"
}

variable "project_id" {
  type        = string
  default     = null
  description = "GCP project ID (required if sink_type is project)"
}

variable "folder_id" {
  type        = string
  default     = null
  description = "Folder ID (required if sink_type is folder)"
}

variable "org_id" {
  type        = string
  default     = null
  description = "Organization ID (required if sink_type is organization)"
}

variable "name" {
  type        = string
  description = "Log sink name"
}

variable "destination" {
  type        = string
  description = "Sink destination URI"
}

variable "filter" {
  type        = string
  default     = ""
  description = "Log filter expression"
}

variable "exclusions" {
  type = list(object({
    name        = string
    filter      = string
    description = string
    disabled    = bool
  }))
  default = []
  description = "List of exclusion filters for this sink"
}

variable "bucket_depends_on" {
  type        = list(any)
  default     = []
  description = "List of resources the sink depends on"
}