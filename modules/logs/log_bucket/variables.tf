variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "name" {
  type        = string
  description = "Log bucket name"
}

variable "location" {
  type        = string
  default     = "global"
  description = "Location for the log bucket"
}

variable "retention_days" {
  type        = number
  description = "Number of days to retain logs"
}

variable "description" {
  type        = string
  default     = ""
}

variable "labels" {
  type        = map(string)
  default     = {}
}

variable "views" {
  type = list(object({
    name        = string
    filter      = string
    description = string
  }))
  default     = []
  description = "Lista widoków do utworzenia w bucket (log views)"
}

variable "view_iam_bindings" {
  type = list(object({
    view_name = string
    role      = string
    members   = list(string)
  }))
  default     = []
  description = "Lista IAM bindings dla log views (przypisania ról do widoków)"
}