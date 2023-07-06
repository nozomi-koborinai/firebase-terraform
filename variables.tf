variable "billing_account" {
  description = "Firebase プロジェクトに紐づける Google Cloud Billing Account の ID"
  type        = string
}

variable "project_name" {
  description = "Firebase プロジェクトの名前"
  type        = string
}

variable "project_id" {
  description = "Firebase プロジェクトの ID（世界で一意となるコード）"
  type        = string
}

variable "android_package_name" {
  description = "パッケージ名（Android）"
  type        = string
}

variable "ios_bundle_id" {
  description = "バンドルID（iOS）"
  type        = string
}