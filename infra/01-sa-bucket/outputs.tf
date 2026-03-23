output "service_account_id" {
  value = yandex_iam_service_account.terraform-sa.id
}

output "service_account_name" {
  value = yandex_iam_service_account.terraform-sa.name
}

output "s3_bucket_name" {
  value = yandex_storage_bucket.tf-state.bucket
}

output "s3_access_key" {
  value = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  sensitive = true
}

output "s3_secret_key" {
  value = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive = true
}

output "key_pem_file" {
  value = "key.pem file created in ${path.module}"
}