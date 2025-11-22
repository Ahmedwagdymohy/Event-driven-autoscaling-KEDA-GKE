# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "service-a" {
  account_id = "service-a"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "service-a" {
  project = "supple-alpha-474315-q5"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.service-a.email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "service-a" {
  service_account_id = google_service_account.service-a.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:supple-alpha-474315-q5.svc.id.goog[staging/service-a]"
}

# KEDA demo service account
resource "google_service_account" "keda-demo" {
  account_id = "keda-demo"
  project    = "supple-alpha-474315-q5"
}

# IAM role binding for keda-demo service account
resource "google_project_iam_member" "keda-demo" {
  project = "supple-alpha-474315-q5"
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.keda-demo.email}"
}

# Allow kubernetes service account to impersonate GCP service account
resource "google_service_account_iam_member" "keda-demo" {
  service_account_id = google_service_account.keda-demo.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:supple-alpha-474315-q5.svc.id.goog[default/keda-demo]"
}