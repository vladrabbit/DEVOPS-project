output "vpc_id" {
  value = yandex_vpc_network.k8s_network.id
}

output "vpc_name" {
  value = yandex_vpc_network.k8s_network.name
}

output "subnet_a_id" {
  value = yandex_vpc_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = yandex_vpc_subnet.subnet_b.id
}

output "subnet_d_id" {
  value = yandex_vpc_subnet.subnet_d.id
}

output "subnet_a_cidr" {
  value = yandex_vpc_subnet.subnet_a.v4_cidr_blocks
}

output "subnet_b_cidr" {
  value = yandex_vpc_subnet.subnet_b.v4_cidr_blocks
}

output "subnet_d_cidr" {
  value = yandex_vpc_subnet.subnet_d.v4_cidr_blocks
}