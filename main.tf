# Firebase プロジェクト用の Google Cloud プロジェクトを立ち上げる
resource "google_project" "default" {
  provider = google-beta

  # project_id は全世界で一意になる必要がある
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
  source         = "./modules/storage"
  project_id     = var.project_id
  location       = local.region
  services_ready_1 = module.firestore.firestore_database
  services_ready_2 = google_firebase_project.default
}