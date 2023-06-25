# Creates a new Google Cloud project .
resource "google_project" "default" {
  provider = google-beta.no_user_project_override

  name       = "terraform-koborinai"
  project_id = "terraform-koborinai"

  # Required for any service that requires the Blaze pricing plan
  # (like Firecbase Authentication with GCIP)
  billing_account = var.billing_account

  # Required for the project to display in any list of Firebase projects.
  labels = {
    "firebase" = "enabled"
  }
}

# Enables required APIs .
resource "google_project_service" "default" {
  provider = google-beta.no_user_project_override
  project  = google_project.default.project_id
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "firebase.googleapis.com",
    # Enabling the ServiceUsage API allows the new project to be quota checked from now on.
    "serviceusage.googleapis.com",
  ])
  service = each.key
  # Don't disable the service if the resource block is removed by accident.
  disable_on_destroy = false
}

# Enables Firebase services for the new project created above.
resource "google_firebase_project" "default" {
  provider = google-beta
  project  = google_project.default.project_id
  depends_on = [
    google_project_service.default
  ]
}

resource "google_firebase_project_location" "basic" {
  provider = google-beta
  project  = google_firebase_project.default.project

  location_id = "asia-northeast1"
}