# Firebase Firestore インスタンス
resource "google_firestore_database" "default" {
  project                     = var.project_id
  name                        = "(default)"
  location_id                 = var.location
  type                        = "FIRESTORE_NATIVE"
  concurrency_mode            = "OPTIMISTIC"

  depends_on = [
    var.services_ready
  ]
}

# Firebase Firestore コレクション／ドキュメント定義
resource "google_firestore_document" "mydoc" {
  project     = var.project_id
  collection  = "somenewcollection"
  document_id = "my-doc-id"
  fields      = "{\"something\":{\"mapValue\":{\"fields\":{\"akey\":{\"stringValue\":\"avalue\"}}}}}"
  depends_on = [google_firestore_database.default]
}
resource "google_firestore_document" "sub_document" {
  project     = var.project_id
  collection  = "${google_firestore_document.mydoc.path}/subdocs"
  document_id = "bitcoinkey"
  fields      = "{\"something\":{\"mapValue\":{\"fields\":{\"ayo\":{\"stringValue\":\"val2\"}}}}}"
  depends_on = [google_firestore_database.default]

}
resource "google_firestore_document" "sub_sub_document" {
  project     = var.project_id
  collection  = "${google_firestore_document.sub_document.path}/subsubdocs"
  document_id = "asecret"
  fields      = "{\"something\":{\"mapValue\":{\"fields\":{\"secret\":{\"stringValue\":\"hithere\"}}}}}"
  depends_on = [google_firestore_database.default]
}