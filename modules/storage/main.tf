# Firebase Cloud Storage

# App Engine の有効化が必要
resource "google_app_engine_application" "default" {
  project     = var.project_id
  location_id = var.location

  # Firestore DB を作成する場合は、その作成を待つ必要がある
  depends_on = [
    var.services_ready_1
  ]
}

# Storage バケット
resource "google_firebase_storage_bucket" "default" {
  provider  = google-beta
  project   = var.project_id
  bucket_id = google_app_engine_application.default.default_bucket
}