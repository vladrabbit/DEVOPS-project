variable "folder_id" {
  type        = string
  description = "Yandex Cloud folder ID"
}

variable "cloud_id" {
  type        = string
  description = "Yandex Cloud cloud ID"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = "devops-k8s-vpc"
}

variable "subnet_a_cidr" {
  type        = string
  description = "CIDR for subnet in ru-central1-a"
  default     = "10.1.0.0/24"
}

variable "subnet_b_cidr" {
  type        = string
  description = "CIDR for subnet in ru-central1-b"
  default     = "10.2.0.0/24"
}

variable "subnet_d_cidr" {
  type        = string
  description = "CIDR for subnet in ru-central1-d"
  default     = "10.3.0.0/24"
}