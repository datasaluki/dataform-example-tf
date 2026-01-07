variable "suffix" {
  type        = string
  description = "The suffix to use in bucket names, etc."
}

variable "location" {
  type        = string
  description = "The location to store data in"
}

variable "source_files" {
  type        = list(any)
  description = "The list of source files to upload"
  default     = ["category", "sub_category", "product", "courier", "shipping_method", "customer", "order", "order_item"]
}
