
data "google_billing_account" "selected" {
  billing_account = var.billing_account_id
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_bigquery_dataset" "billing_export" {
  dataset_id = "billing_export"
  project    = var.project_id
  location   = "EU"
}


resource "google_billing_account_iam_member" "billing_viewer" {
  billing_account_id = data.google_billing_account.selected.id
  role               = "roles/billing.viewer"
  member             = "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com"
}

resource "google_bigquery_dataset_iam_member" "cloudservices_writer" {
  dataset_id = google_bigquery_dataset.billing_export.dataset_id
  project    = var.project_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com"
}