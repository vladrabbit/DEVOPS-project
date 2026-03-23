
resource "yandex_storage_bucket" "tf-state" {
  bucket     = "tf-state-devops-k8s-${var.folder_id}"
  folder_id  = var.folder_id
  

  versioning {
    enabled = true
  }
  

  force_destroy = false
}