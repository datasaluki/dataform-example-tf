resource "google_bigquery_dataset" "target_dataset" {
  dataset_id = "dataform_example_target"
  location   = var.location
}
