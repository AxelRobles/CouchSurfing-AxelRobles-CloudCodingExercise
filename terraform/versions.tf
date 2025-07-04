terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  backend "gcs" {
    bucket  = "axel-robles-couchsurfing-test"
    prefix  = "couchsurfing/prod"
  }
}