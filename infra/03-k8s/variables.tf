variable "cloud_id" {
  type        = string
  description = "Yandex Cloud cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud folder ID"
}

variable "service_account_id" {
  type        = string
  description = "Service account ID for K8s"
}

variable "network_id" {
  type        = string
  description = "VPC network ID"
}

variable "subnet_a" {
  type        = string
  description = "Subnet A ID (ru-central1-a)"
}

variable "subnet_b" {
  type        = string
  description = "Subnet B ID (ru-central1-b)"
}

variable "subnet_d" {
  type        = string
  description = "Subnet D ID (ru-central1-d)"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.31"
}