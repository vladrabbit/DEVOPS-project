terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    bucket  = "tf-state-devops-k8s-b1gfstkmnmnullc78emb"
    key     = "terraform.tfstate"
    region  = "ru-central1"
    profile = "yc"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}