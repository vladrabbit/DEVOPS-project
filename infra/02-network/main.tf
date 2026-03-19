terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.190.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "../01-sa-bucket/sa-key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}

# VPC
resource "yandex_vpc_network" "k8s_network" {
  name = var.vpc_name
}

# Subnet A
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "k8s-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = [var.subnet_a_cidr]
}

# Subnet B
resource "yandex_vpc_subnet" "subnet_b" {
  name           = "k8s-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = [var.subnet_b_cidr]
}

# Subnet C
resource "yandex_vpc_subnet" "subnet_c" {
  name           = "k8s-subnet-c"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = [var.subnet_c_cidr]
}