variable "project_id" {
  type        = string
  description = "Project, w którym powstaną wszystkie buckety"
}

variable "buckets" {
  description = <<EOF
Mapa konfiguracji bucketów.
Klucz mapy = nazwa bucketu (bucket_id).
Wartość = obiekt z parametrami:
  location        – string     (domyślnie "global")
  retention_days  – number     (wymagane)
  description     – string     (opcjonalnie)
  views           – list(...)
  view_iam_bindings – list(...)
EOF
  type = map(object({
    location          = optional(string, "global")
    retention_days    = number
    description       = optional(string, "")
    views             = optional(list(object({
                         name        = string
                         filter      = string
                         description = string
                       })), [])
    view_iam_bindings = optional(list(object({
                         view_name = string
                         role      = string
                         members   = list(string)
                       })), [])
  }))
}