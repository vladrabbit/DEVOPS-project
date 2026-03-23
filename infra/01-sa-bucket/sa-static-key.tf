
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.terraform-sa.id
  description        = "Static access key for S3 operations"
}