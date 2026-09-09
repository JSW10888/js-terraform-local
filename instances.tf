resource "google_compute_instance" "tf-instance-1"{
    name         = "tf-instance-1"
    machine_type = "n1-standard-1"
    zone         = var.zone

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-10"
        }
    }
    network_interface {
        network = "default"
    }
    metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
    allowed_stopping_for_update = true
}
resource "google_compute_instance" "tf-instance-2"{
    name         = "tf-instance-2"
    machine_type = "n1-standard-1"
    zone         = var.zone

    boot_disk{
        initialize_params{
            image = "debian-cloud/debian-10"
        }
    }
    network_interface{
        network = "default"
    }
    metadata_startup_script=<<-EOT
        #!/bin/bash
    EOT
    allowed_stopping_for_update = true
}

module "gcs_buckets" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 12.3"
  project_id  = "<virtual-cairn-479923-u1>"
  names = ["Jennifer", "Spencer"]
  prefix = "my-unique-prefix"
  set_admin_roles = true
  admins = ["jenni.spencer910@gmail.com"]
  versioning = {
    first = true
  }
  bucket_admins = {
    second = "jenni.spencer910@gmail.com"
  }
}