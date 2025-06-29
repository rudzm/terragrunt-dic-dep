variable "project_id" {
  type        = string
  description = "Domyślny project dla sinków typu project"
}

variable "sinks" {
  type = map(object({
    sink_type   = string
    destination = string
    filter      = optional(string, "")
    exclusions = optional(list(object({
      name        = string
      filter      = string
      description = string
      disabled    = bool
    })), [])
    project_id             = optional(string)
    folder_id              = optional(string)
    org_id                 = optional(string)
    unique_writer_identity = optional(bool, false)
  }))
  description = "Mapa sinków do utworzenia"
}