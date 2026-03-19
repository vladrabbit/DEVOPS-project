resource "yandex_container_registry" "registry" {
  name = "k8s-registry"
}

resource "yandex_container_registry_iam_binding" "push_pull" {
  registry_id = yandex_container_registry.registry.id
  role        = "container-registry.images.pusher"

  members = [
    "serviceAccount:${var.service_account_id}"
  ]
}