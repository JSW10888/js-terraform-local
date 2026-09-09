terraform {
  backend "gcs" {
    credentials = "C:/virtual-cairn-479923-u1-1ce6c96bd728.json" #PROBLEMATIC
    bucket = "virtual-cairn-479923-u1-1ce6c96bd728"
    prefix = "terraform/state"
  }
}
data "terraform_remote_state" "virtual-cairn-479923-u1" {
  backend   = "gcp"
  workspace = "${terraform.workspace}"

  config = {
    bucket = "${var.bucket_name}"
    prefix = "${var.prefix_project}"
    credentials = "${var.credentials}"  <- added
  }
}

resource "google_apihub_api_hub_instance" "apihub-instance-without-search"{
    location = "us-east4"
    config {
        disable_search = true
    }
}