
resource "yandex_iam_service_account" "terraform-sa" {
  name        = "terraform-sa-devops-k8s"
  description = "Service account for Terraform DevOps project"
  folder_id   = var.folder_id
}


resource "yandex_resourcemanager_folder_iam_member" "vpc-admin" {
  folder_id = var.folder_id
  role      = "vpc.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-sa.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "compute-admin" {
  folder_id = var.folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-sa.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-sa.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "container-registry-admin" {
  folder_id = var.folder_id
  role      = "container-registry.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-sa.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "storage-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-sa.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "load-balancer-admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-sa.id}"
}