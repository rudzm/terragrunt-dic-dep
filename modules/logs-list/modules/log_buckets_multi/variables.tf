
variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "buckets" {
  description = "Map of log buckets and their configuration"
  type = map(object({
    location       = string
    retention_days = optional(number)
    description    = optional(string)
    views = optional(list(object({
      name        = string
      filter      = string
      description = optional(string)
    })))
    view_iam_bindings = optional(list(object({
      view_name = string
      role      = string
      members   = list(string)
    })))
  }))
}
