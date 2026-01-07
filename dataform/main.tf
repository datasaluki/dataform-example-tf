terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
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

provider "google-beta" {
  region = "europe-west1"
}

data "google_project" "project" {

}

data "google_secret_manager_secret_version" "git_ssh_key" {
  secret = var.git_secret_id
}

resource "google_dataform_repository" "dataform_repository" {
  provider     = google-beta
  name         = "dataform-example-repo"
  display_name = "dataform-example-repo"

  service_account = var.service_account_email

  deletion_policy = "FORCE"

  git_remote_settings {
    url            = var.git_repo_url
    default_branch = var.git_default_branch

    ssh_authentication_config {
      user_private_key_secret_version = data.google_secret_manager_secret_version.git_ssh_key.name
      host_public_key                 = var.git_host_public_key
    }
  }

  workspace_compilation_overrides {
    # Set the default database to be the name of the project being provisioned in
    default_database = replace(data.google_project.project.id, "projects/", "")
  }
}

resource "google_dataform_repository_release_config" "release" {
  provider = google-beta

  project    = google_dataform_repository.dataform_repository.project
  region     = google_dataform_repository.dataform_repository.region
  repository = google_dataform_repository.dataform_repository.name

  name          = "main-release-config"
  git_commitish = "main"
  cron_schedule = "0 9 * * *"
  time_zone     = "UTC"

  code_compilation_config {
    default_database = google_dataform_repository.dataform_repository.project
    assertion_schema = "dataform_example_assertion"

    vars = {
      sourceSchema = "dataform_example_source"
    }
  }
}

resource "google_dataform_repository_workflow_config" "workflow" {
  provider = google-beta

  project        = google_dataform_repository.dataform_repository.project
  region         = google_dataform_repository.dataform_repository.region
  repository     = google_dataform_repository.dataform_repository.name
  name           = "main-workflow-config"
  release_config = google_dataform_repository_release_config.release.id

  invocation_config {
    included_targets {

    }
    service_account = var.service_account_email
  }

  cron_schedule = "10 7 * * *"
  time_zone     = "UTC"
}
