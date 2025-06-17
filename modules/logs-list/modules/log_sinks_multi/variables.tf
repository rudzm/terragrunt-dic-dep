variable "project_id" {
  type        = string
  description = "Domyślny project dla sinków typu project"
}

variable "sinks" {
  description = <<EOF
Mapa sinków. Klucz = nazwa sinka.
Wartość = obiekt:
  sink_type   – "project" | "folder" | "organization"
  destination – pełny URI
  filter      – string (opcjonalny)
  exclusions  – list(...)
  project_id  – string (gdy sink_type="project")
  folder_id   – string (gdy "folder")
  org_id      – string (gdy "organization")
EOF
  type = map(object({
    sink_type   = string
    destination = string
    filter      = optional(string, "")
    exclusions  = optional(list(object({
                     name        = string
                     filter      = string
                     description = string
                     disabled    = bool
                   })), [])
    project_id  = optional(string)
    folder_id   = optional(string)
    org_id      = optional(string)
  }))
}