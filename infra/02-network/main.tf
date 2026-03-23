terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
  required_version = ">= 1.0"
  
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    bucket  = "tf-state-devops-k8s-b1gfstkmnmnullc78emb"
    key     = "02-network/terraform.tfstate"
    region  = "ru-central1"
    profile = "yc"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
  service_account_key_file = "${path.module}/key.json"
}


resource "yandex_vpc_network" "k8s_network" {
  name = var.vpc_name
}


resource "yandex_vpc_subnet" "subnet_a" {
  name           = "k8s-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = [var.subnet_a_cidr]
}


resource "yandex_vpc_subnet" "subnet_b" {
  name           = "k8s-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = [var.subnet_b_cidr]
}

resource "yandex_vpc_subnet" "subnet_d" {
  name           = "k8s-subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = [var.subnet_d_cidr]
}