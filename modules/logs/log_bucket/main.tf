resource "google_logging_project_bucket_config" "log_bucket" {
  project         = var.project_id
  location        = var.location
  retention_days  = var.retention_days
  bucket_id       = var.name
  description     = var.description
  labels          = var.labels
}