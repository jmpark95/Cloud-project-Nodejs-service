terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_credentials)
  # credentials = var.gcp_credentials
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  credentials = file(var.gcp_credentials)
  # credentials = var.gcp_credentials
  project = var.project
  region  = var.region
  zone    = var.zone
}

