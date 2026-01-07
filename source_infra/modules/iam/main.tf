data "google_project" "project" {

}

resource "google_service_account" "dataform_example_service_account" {
  account_id   = "dataform-example-sa"
  display_name = "Dataform Example Service Account"
}

# Grant big query job user access
resource "google_project_iam_member" "service_account_job_user" {
  project = data.google_project.project.id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dataform_example_service_account.email}"
}

# Grant editor access to datasets
resource "google_bigquery_dataset_iam_member" "service_account_source_editor" {
  dataset_id = var.source_dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dataform_example_service_account.email}"
}

resource "google_bigquery_dataset_iam_member" "service_account_target_editor" {
  dataset_id = var.target_dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dataform_example_service_account.email}"
}

# Grant access to the dataform service account to use the custom service account, Without this, the custom account can't be used to execute workflows.
resource "google_service_account_iam_member" "dataform_service_account_user_access" {
  service_account_id = google_service_account.dataform_example_service_account.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-dataform.iam.gserviceaccount.com"
}
resource "google_service_account_iam_member" "dataform_service_account_user_token_creator" {
  service_account_id = google_service_account.dataform_example_service_account.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-dataform.iam.gserviceaccount.com"
}
