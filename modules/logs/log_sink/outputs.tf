output "writer_identity" {
  value = (
    var.sink_type == "project" ? google_logging_project_sink.log_sink[0].writer_identity :
    var.sink_type == "folder" ? google_logging_folder_sink.log_sink[0].writer_identity :
    google_logging_organization_sink.log_sink[0].writer_identity
  )
}