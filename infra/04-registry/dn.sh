#!/bin/bash
set -e

# Каталог с Terraform конфигурацией кластера
K8S_DIR=~/DEVOPS_project/infra/03-k8s

echo "Перехожу в каталог кластера: $K8S_DIR"
cd "$K8S_DIR"

echo "Проверяю план удаления (dry-run)"
terraform plan -destroy

read -p "Продолжить и удалить все VM кластера? [y/N]: " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Отмена удаления."
  exit 0
fi

echo "Удаляю Kubernetes cluster и node groups..."
terraform destroy -auto-approve

echo "Удаление VM завершено! Сеть и Registry не тронуты."