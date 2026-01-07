resource "google_bigquery_table" "table" {
  dataset_id = var.dataset_id
  table_id   = var.table_id
  schema     = jsonencode(var.fields)

  external_data_configuration {

    autodetect    = false
    source_format = "CSV"

    csv_options {
      skip_leading_rows = 1
      quote             = "\""
    }

    source_uris = [var.source_uri]

    connection_id       = var.connection_id
    metadata_cache_mode = "AUTOMATIC"
  }

  max_staleness       = "0-0 0 10:0:0"
  deletion_protection = false
}
