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

variable "bucket_name" {
  description = ".tfstate ファイルが保存される Cloud Storage バケットの名前"
  type        = string
}