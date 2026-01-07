resource "google_bigquery_dataset" "target_dataset" {
  dataset_id = "dataform_example_target"
  location   = var.location
}

resource "google_bigquery_dataset" "assertion_dataset" {
  dataset_id = "dataform_example_assertion"
  location   = var.location
}
