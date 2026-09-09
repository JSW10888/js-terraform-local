#roles/compute.admin
#roles/storage.admin
#roles/iam.serviceAccountUser

resource "google_project_iam_binding" "storage-iam" {
    project = "virtual-cairn-479923-u1"
    role = "roles/storage.admin"
    members = [
        "serviceAccount:${google_service_account.store_user.email}",
    ]
}
resource "google_project_iam_binding" "pubsub-iam" {
    project = virtual-cairn-479923-u1
    role = "roles/pubsub.admin"
    members = [
        "serviceAccount:${google_service_account.store_user.email}",
    ]
}