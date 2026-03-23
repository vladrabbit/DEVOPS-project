data "yandex_vpc_network" "k8s_network" {
  network_id = var.network_id
}

data "yandex_vpc_subnet" "subnet_a" {
  subnet_id = var.subnet_a
}

data "yandex_vpc_subnet" "subnet_b" {
  subnet_id = var.subnet_b
}

data "yandex_vpc_subnet" "subnet_d" {
  subnet_id = var.subnet_d
}