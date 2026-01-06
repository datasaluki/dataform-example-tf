output "source_bucket_name" {
  value = google_storage_bucket.source_data_bucket.name
}

output "source_dataset_id" {
  value = google_bigquery_dataset.source_data.dataset_id
}
