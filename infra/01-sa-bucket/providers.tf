terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "./sa-key.json"
  cloud_id = "b1g9acd7na9ei6dvlt8k"
  folder_id = var.folder_id 
  zone = "ru-central1-a"
}