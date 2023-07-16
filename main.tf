# Firebase プロジェクト用の Google Cloud プロジェクトを立ち上げる
resource "google_project" "default" {
  provider = google-beta.no_user_project_override

  # project_id は一意である必要がある
  project_id      = var.project_id
  name            = var.project_name
  billing_account = var.billing_account

  # Firebase のプロジェクトとして表示するために必要
  labels = {
    "firebase" = "enabled"
  }
}

# 各種 API を有効化する
resource "google_project_service" "default" {
  provider = google-beta.no_user_project_override
  project  = google_project.default.project_id
  for_each = toset([
    "cloudbuild.googleapis.com",
    "firestore.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "identitytoolkit.googleapis.com",
    "firebase.googleapis.com",
    "firebaserules.googleapis.com",
    "firebasestorage.googleapis.com",
    "storage.googleapis.com",
  ])
  service            = each.key
  disable_on_destroy = false
}

# Firebase のプロジェクトを立ち上げる
resource "google_firebase_project" "default" {
  provider = google-beta
  project  = google_project.default.project_id

  # 各種 API が有効化されるのを待ってから 本リソースが実行される
  depends_on = [
    google_project_service.default,
  ]
}

# Firebase プロジェクトを東京リージョンに配置する
resource "google_firebase_project_location" "default" {
  provider = google-beta
  project  = google_firebase_project.default.project

  location_id = local.region
}

# Firebase Web App
resource "google_firebase_web_app" "default" {
  provider     = google-beta
  project      = var.project_id
  display_name = "My Web App"

  depends_on = [
    google_firebase_project.default,
  ]
}

# Firebase Android App
resource "google_firebase_android_app" "default" {
  provider     = google-beta
  project      = var.project_id
  display_name = "My Android App"
  package_name = var.android_package_name

  depends_on = [
    google_firebase_project.default,
  ]
}

# Firebase iOS App
resource "google_firebase_apple_app" "default" {
  provider     = google-beta
  project      = var.project_id
  display_name = "My iOS app"
  bundle_id    = var.ios_bundle_id

  depends_on = [
    google_firebase_project.default,
  ]
}

# 各種モジュールに locals ファイルを渡す
## Firebase Authentication
module "authentication" {
  source         = "./modules/authentication"
  project_id     = var.project_id
  services_ready = google_firebase_project.default
}

## Firebase Firestore
module "firestore" {
  source         = "./modules/firestore"
  project_id     = var.project_id
  location       = local.region
  services_ready = google_firebase_project.default
}

## Firebase Cloud Storage
module "storage" {
  source           = "./modules/storage"
  project_id       = var.project_id
  location         = local.region
  services_ready_1 = module.firestore.firestore_database
  services_ready_2 = google_firebase_project.default
}