# Firebase プロジェクト用の Google Cloud プロジェクトを立ち上げる
resource "google_project" "default" {
  provider = google-beta

  # project_id は全世界で一意になる必要がある
  project_id = "firebase-terraform"
  name       = "firebase-terraform"
  billing_account = var.billing_account

  # Firebase のプロジェクトとして表示するために必要
  labels = {
    "firebase" = "enabled"
  }
}

# Firebase のプロジェクトを立ち上げる
resource "google_firebase_project" "default" {
  provider = google-beta
  project  = google_project.default.project_id

  depends_on = [
    google_project_service.default,
  ]
}

# 各種APIを有効化する
resource "google_project_service" "default" {
  provider = google-beta
  project  = google_project.default.project_id
  for_each = toset([
    "cloudbuild.googleapis.com",
    "firestore.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "identitytoolkit.googleapis.com",
  ])
  service = each.key
  disable_on_destroy = false
}

resource "google_firebase_project_location" "default" {
  provider = google-beta
  project  = google_firebase_project.default.project

  location_id = "asia-northeast1"
}