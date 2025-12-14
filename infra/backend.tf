provider "google" {
  project = var.project_id
  region  = var.region
}

provider "hcloud" {
  token = var.hcloud_token
}

terraform {
  required_version = "~> 1.14.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.38.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.45.0"
    }
  }

  backend "gcs" {
    bucket = "state-hetznetes"
    prefix = "main"
  }
}
