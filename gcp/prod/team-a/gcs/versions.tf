terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.22.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.22.0"
    }
  }
  backend "gcs" {}
}

provider "google" {}