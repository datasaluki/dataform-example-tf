
variable "connection_id" {
  description = "The ID of the connection to use for the Big Lake table"
  type        = string
}

variable "dataset_id" {
  type        = string
  description = "The ID of the dataset to create the table in"
}

variable "table_id" {
  type        = string
  description = "The name to give the table"
}

variable "source_uri" {
  type        = string
  description = "The path to the source data in GCS"
}

variable "fields" {
  description = "The fields to use for the schema (will be JSONEncoded)"
  type        = list(any)
}
