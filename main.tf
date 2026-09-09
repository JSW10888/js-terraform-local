terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.22.0"
    }
  }
}
provider "google" {
  project = "virtual-cairn-479923-u1"
  region  = "us-east4"
  zone    = "us-east4-a"
}
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}
resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}
module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 9.0"
  name    = "example-router"
  region  = "us-central1"
  bgp = {
    # The ASN (16550, 64512 - 65534, 4200000000 - 4294967294) can be any private ASN
    # not already used as a peer ASN in the same region and network or 16550 for Partner Interconnect.
    asn = "65001"
  }
  project_id = "virtual-cairn-479923-u1"
  network = "default"
}
data "google_iam_policy" "admin" {
  binding {
    role = "roles/storage.objectViewer"
    members = ["user:jenni.spencer910@gmail.com"]
  }
  audit_config {
    service = "cloudkms.googleapis.com"
    audit_log_configs {
      log_type = "DATA_READ"
      exempted_members = ["admin"]
      }
    audit_log_configs {
      log_type = "DATA_WRITE"
      }
    audit_log_configs {
      log_type = "ADMIN_READ"
      }
    }
  }
module "mysql-db" {
  source  = "terraform-google-modules/sql-db/google//modules/mysql"
  version = "~> 28.2"
  name                 = var.db_name
  random_instance_name = true
  database_version     = "MYSQL_5_6"
  project_id           = var.project_id
  zone                 = "us-east4-a"
  region               = "us-east4"
  tier                 = "db-n1-standard-1"
  deletion_protection = false
  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    ssl_mode            = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    allocated_ip_range  = null
    authorized_networks = var.authorized_networks
  }
  database_flags = [
    {
      name  = "log_bin_trust_function_creators"
      value = "on"
    },
  ]
}
# Aliased provider - targets us-east4
provider "google" {
  alias   = "gcs"
  project = var.project_id
  region  = "us-east4"
  zone    = "us-east4-a"
}
# Aliased provider - targets us-east4
provider "google" {
  alias   = "gcp"
  project = var.project_id
  region  = "us-east4"
  zone    = "us-east4-a"
}
data "google_project" "existing_project" {
  project_id = "virtual-cairn-479923-u1"
}
# Example of referencing the data source elsewhere
output "project_number" {
  value = data.google_project.existing_project.number
}