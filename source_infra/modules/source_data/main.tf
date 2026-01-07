# Data
data "google_project" "project" {

}

# Cloud Storage
resource "google_storage_bucket" "source_data_bucket" {
  name                        = "dataform-example-source-${var.suffix}"
  location                    = var.location
  uniform_bucket_level_access = true
  force_destroy               = true
  hierarchical_namespace {
    enabled = true
  }
}

# Upload the source data
resource "google_storage_bucket_object" "source_file" {

  for_each = toset(var.source_files)
  bucket   = google_storage_bucket.source_data_bucket.name
  name     = "${each.key}/${each.key}_0.csv"
  source   = "${path.root}/../data/${each.key}.csv"
}


# Big Lake Tables
resource "google_bigquery_dataset" "source_data" {
  dataset_id  = "dataform_example_source"
  description = "Source data for the dataform example"
  location    = var.location
}

resource "google_bigquery_connection" "biglake_connection" {
  connection_id = "dataform-example-biglake-connection"
  location      = var.location
  description   = "The connection to use for the source tables for BigLake"

  cloud_resource {
  }
}


# Grant the big lake connection service account access to google storage - without this you'll get an access error when trying to query
resource "google_project_iam_member" "service_account_storage_access" {
  project = data.google_project.project.id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_bigquery_connection.biglake_connection.cloud_resource[0].service_account_id}"
}

module "category_table" {

  source        = "./biglake_table"
  connection_id = google_bigquery_connection.biglake_connection.name
  dataset_id    = google_bigquery_dataset.source_data.dataset_id
  table_id      = "category"
  source_uri    = "gs://${google_storage_bucket.source_data_bucket.name}/category/*.csv"
  fields        = [{ "name" : "id", "type" : "int64" }, { "name" : "name", "type" : "string" }]
}

module "sub_category_table" {

  source        = "./biglake_table"
  connection_id = google_bigquery_connection.biglake_connection.name
  dataset_id    = google_bigquery_dataset.source_data.dataset_id
  table_id      = "sub_category"
  source_uri    = "gs://${google_storage_bucket.source_data_bucket.name}/sub_category/*.csv"
  fields        = [{ "name" : "id", "type" : "int64" }, { "name" : "category_id", "type" : "int64" }, { "name" : "name", "type" : "string" }]
}

module "product_table" {

  source        = "./biglake_table"
  connection_id = google_bigquery_connection.biglake_connection.name
  dataset_id    = google_bigquery_dataset.source_data.dataset_id
  table_id      = "product"
  source_uri    = "gs://${google_storage_bucket.source_data_bucket.name}/product/*.csv"
  fields        = [{ "name" : "id", "type" : "int64" }, { "name" : "sub_category_id", "type" : "int64" }, { "name" : "name", "type" : "string" }, { "name" : "price", "type" : "numeric" }]
}

module "courier_table" {

  source        = "./biglake_table"
  connection_id = google_bigquery_connection.biglake_connection.name
  dataset_id    = google_bigquery_dataset.source_data.dataset_id
  table_id      = "courier"
  source_uri    = "gs://${google_storage_bucket.source_data_bucket.name}/courier/*.csv"
  fields        = [{ "name" : "id", "type" : "int64" }, { "name" : "name", "type" : "string" }]
}

module "shipping_method_table" {

  source        = "./biglake_table"
  connection_id = google_bigquery_connection.biglake_connection.name
  dataset_id    = google_bigquery_dataset.source_data.dataset_id
  table_id      = "shipping_method"
  source_uri    = "gs://${google_storage_bucket.source_data_bucket.name}/shipping_method/*.csv"
  fields        = [{ "name" : "id", "type" : "int64" }, { "name" : "name", "type" : "string" }]
}

module "customer_table" {

  source        = "./biglake_table"
  connection_id = google_bigquery_connection.biglake_connection.name
  dataset_id    = google_bigquery_dataset.source_data.dataset_id
  table_id      = "customer"
  source_uri    = "gs://${google_storage_bucket.source_data_bucket.name}/customer/*.csv"
  fields        = [{ "name" : "id", "type" : "int64" }, { "name" : "city", "type" : "string" }, { "name" : "country", "type" : "string" }]
}

module "order_table" {

  source        = "./biglake_table"
  connection_id = google_bigquery_connection.biglake_connection.name
  dataset_id    = google_bigquery_dataset.source_data.dataset_id
  table_id      = "order"
  source_uri    = "gs://${google_storage_bucket.source_data_bucket.name}/order/*.csv"
  fields        = [{ "name" : "id", "type" : "int64" }, { "name" : "customer_id", "type" : "int64" }, { "name" : "shipping_method_id", "type" : "int64" }, { "name" : "courier_id", "type" : "int64" }, { "name" : "placed_timestamp", "type" : "timestamp" }, { "name" : "shipped_timestamp", "type" : "timestamp" }]
}

module "order_item_table" {

  source        = "./biglake_table"
  connection_id = google_bigquery_connection.biglake_connection.name
  dataset_id    = google_bigquery_dataset.source_data.dataset_id
  table_id      = "order_item"
  source_uri    = "gs://${google_storage_bucket.source_data_bucket.name}/order_item/*.csv"
  fields        = [{ "name" : "id", "type" : "int64" }, { "name" : "order_id", "type" : "int64" }, { "name" : "product_id", "type" : "int64" }, { "name" : "quantity", "type" : "int64" }]
}
