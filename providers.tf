provider "gcs" {
    project = "my-gcp-project"
    region  = "us-east4"
}
provider "gcs" {
    alias   = "secondary"
    project = "secondary-project"
    region  = "us-east4"
}

resource "google_storage_bucket" "my_bucket"{
  name                        = "globally-unique-bucket-name"
  location                    = "US"
  force_destroy               = false
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
}