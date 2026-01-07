variable "git_repo_url" {
  type        = string
  description = "The path to your git repo"
}

variable "git_default_branch" {
  type        = string
  description = "The default branch for dataform to use in git"
  default     = "main"
}

variable "git_secret_id" {
  type        = string
  description = "The ID of the secret in secrets manager containing the secret for connecting to git (e.g. a private SSH key for GitHub)"
}

variable "git_host_public_key" {
  type        = string
  description = "The public key for the git host"
}

variable "location" {
  type        = string
  description = "The location to store data in"
}

variable "service_account_email" {
  type        = string
  description = "The email address of the service account to use for dataform"
}
