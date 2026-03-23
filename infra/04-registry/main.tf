resource "yandex_container_registry" "registry" {
  name       = "devops-registry"
  folder_id  = var.folder_id
}

resource "yandex_container_registry_iam_binding" "registry-puller" {
  registry_id = yandex_container_registry.registry.id
  role        = "container-registry.images.puller"
  members = [
    "serviceAccount:${var.service_account_id}",
  ]
}