
resource "yandex_iam_service_account_key" "sa-json-key" {
  service_account_id = yandex_iam_service_account.terraform-sa.id
  description        = "PEM key for Terraform provider"
  key_algorithm      = "RSA_2048"
}


resource "local_file" "sa-key-json" {
  content  = yandex_iam_service_account_key.sa-json-key.private_key
  filename = "${path.module}/key.pem"
}