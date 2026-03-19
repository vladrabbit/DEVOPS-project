variable "cloud_id" {}
variable "folder_id" {}
variable "service_account_id" {}

variable "vpc_name" {
  default = "k8s-vpc"
}

variable "subnet_a_cidr" {
  default = "10.10.1.0/24"
}

variable "subnet_b_cidr" {
  default = "10.10.2.0/24"
}

variable "subnet_c_cidr" {
  default = "10.10.3.0/24"
}