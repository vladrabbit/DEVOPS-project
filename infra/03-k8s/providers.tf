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
    key     = "03-k8s/terraform.tfstate"
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