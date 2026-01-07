output "target_dataset_id" {
  value = google_bigquery_dataset.target_dataset.dataset_id
}

output "assertion_dataset_id" {
  value = google_bigquery_dataset.assertion_dataset.dataset_id
}
