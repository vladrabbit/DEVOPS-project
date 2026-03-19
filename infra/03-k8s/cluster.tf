resource "yandex_kubernetes_cluster" "k8s" {
  name        = "k8s-cluster"
  description = "Terraform managed K8s cluster"

  network_id = var.network_id

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = "ru-central1-a"
        subnet_id = var.subnet_a
      }

      location {
        zone      = "ru-central1-b"
        subnet_id = var.subnet_b
      }

      location {
        zone      = "ru-central1-d"
        subnet_id = var.subnet_c
      }
    }

    public_ip = true

    version = var.k8s_version

    maintenance_policy {
      auto_upgrade = true
    }
  }
}

resource "yandex_kubernetes_node_group" "default_pool" {
  cluster_id = yandex_kubernetes_cluster.k8s.id
  name       = "default-node-group"

  version = var.k8s_version

  instance_template {
    platform_id = "standard-v2" # дешевле, чем v3

    resources {
      cores       = 2
      memory      = 4
    }
     scheduling_policy {
      preemptible = true
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    network_interface {
      subnet_ids = [var.subnet_a, var.subnet_b, var.subnet_c] # распределяем ноды по подсетям
      nat        = true
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    # Можно указать несколько зон для распределения нод
    location {
      zone = "ru-central1-a"
    }
    location {
      zone = "ru-central1-b"
    }
    location {
      zone = "ru-central1-d"
    }
  }
}