terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.14.1"
    }
    random = {
      source  = "hashicorp/random",
      version = ">= 3.7.2"
    }
  }

  backend "gcs" {

  }
}

provider "google" {
  region = "europe-west1"
}


resource "random_id" "suffix" {
  byte_length = 8
}

module "source_data" {
  source   = "./modules/source_data"
  suffix   = random_id.suffix.hex
  location = var.location
}

module "target_data" {
  source   = "./modules/target_data"
  location = var.location
}

module "iam" {
  source               = "./modules/iam"
  source_dataset_id    = module.source_data.source_dataset_id
  target_dataset_id    = module.target_data.target_dataset_id
  assertion_dataset_id = module.target_data.assertion_dataset_id
}
