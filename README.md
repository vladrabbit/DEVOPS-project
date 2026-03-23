# Дипломный практикум в Yandex.Cloud

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)

## Пошаговое выполнение практикума 

---

##### - Структура проекта DEVOPS

| Категория                  | Папка/Файл                                         | Описание                                                      |
|-----------------------------|---------------------------------------------------|---------------------------------------------------------------|
| Terraform инфраструктура    | infra/01-sa-bucket/                               | Создание сервисного аккаунта и S3 бакета для состояния Terraform |
|                             | infra/02-network/                                 | Конфигурация сетей (VPC, подсети, маршруты)                  |
|                             | infra/03-k8s/                                    | Создание кластера Kubernetes через Terraform                 |
|                             | infra/04-registry/                                | Создание Yandex Container Registry                            |
| Docker тестового приложения | app/Dockerfile                                   | Dockerfile для тестового приложения                           |
|                             | app/index.html                                   | Пример фронтенда приложения                                    |
|                             | app/nginx.conf                                   | Конфигурация nginx                                             |
| CI/CD                       | .github/workflows/deploy.yml                      | GitHub Actions workflow для сборки, пуша Docker и деплоя на k8s |
| Kubernetes конфигурация     | k8s/                                             | Манифесты деплоя тестового приложения и мониторинга (Grafana/Prometheus) |
| Документация                | README.md                                        | Инструкции по проекту, ссылки на тестовое приложение и Grafana |

---

#### 1. Состояние облака перед стартом проекта

![scr-1](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/before_start.png)

---

#### 2. Создаем сервисный аккаунт, S3 bucket, назначаем роли и генерим ключи для S3

![scr-2](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_a_start.png)
![scr-3](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_a_finish.png)

- Создан сервисный аккаунт terraform-sa-devops-k8s для автоматизации

- Назначены роли: vpc.admin, compute.admin, k8s.clusters.agent, container-registry.admin, storage.admin, load-balancer.admin

- Сгенерирован статический ключ доступа для S3 (используется для backend)

- Сгенерирован PEM ключ для аутентификации (сохранен в key.pem)

- Создан S3 бакет tf-state-devops-k8s-b1gfstkmnmnullc78emb с включенным версионированием"

- файл providers.tf на момент запуска 

```hcl
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
  required_version = ">= 1.0"
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
  token     = var.yc_token
}
```

---

#### 3. Миграция state в S3 

```bash
terraform init -reconfigure
```

![scr-5](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_i_reconfigure.png)

- State-файл перенесен из локального хранилища в S3 бакет. Теперь состояние инфраструктуры хранится удаленно, что позволяет работать с ним из разных окружений

---

#### 5. Проверка работы backend

![scr-6](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/T_p_1.png)


- Проверка подтверждает корректную работу удаленного backend. Terraform успешно читает state из S3 и показывает отсутствие изменений в инфраструктуре.

---

#### 6. Создание JSON-ключа для провайдера

```bash
yc iam key create \
  --service-account-id aje7rcqe6pqcfaqo946d \
  --format json \
  --output key.json
```

![scr-4](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/key.png)

---

#### 7. Повторная инициализация с ключом и выполнение terraform plan

- файл providers.tf приведен к виду


```hcl

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
  required_version = ">= 1.0"
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
  service_account_key_file = "${path.module}/key.json"
}

```

- Инициализация с ключом

![scr-7](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/T_I_REC_JSON.png)

- Выполнение terraform plan с ключом

![scr-8](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_p_json.png)


- Проверка созданных ресурсов

```bash
yc iam service-account list
yc iam service-account get aje7rcqe6pqcfaqo946d
yc storage bucket list
yc storage bucket get tf-state-devops-k8s-b1gfstkmnmnullc78emb
```

![scr-14](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/yc_iam_sa.png)
![scr-15](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/yc_storage.png)


---

#### 8. Инициализация и деплой сети

- terraform init

![scr-9](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_i_network.png)

- terraform plan

![scr-10](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/tp_start_net.png)
![scr-11](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/tp_fin_net.png)

- terraform apply

![scr-12](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_a_n_start.png)
![scr-13](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_a_fin_n.png)

- проверка созданных ресурсов

```bash
yc vpc network list
yc vpc network get devops-k8s-vpc
yc vpc subnet list
yc vpc subnet get k8s-subnet-a
yc vpc subnet get k8s-subnet-b
yc vpc subnet get k8s-subnet-d
```

![scr-16](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/yc_network_list.png)
![scr-17](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/yc_subnet_list.png)

---

#### 9. Инициализация и деплой кластера k8s

- terraform init

![scr-18](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_i_cluster.png)

- terraform plan

![scr-19](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_p_start_cluster.png)
![scr-20](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/tp_fin_cluster.png)

- terraform apply

![scr-21](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/ta_start_cluster.png)
![scr-22](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/ta_fin_cluster.png)

- Создан региональный Kubernetes кластер с мастером в трех зонах доступности (ru-central1-a, ru-central1-b, ru-central1-d) и группой из 3 прерываемых worker нод (2 vCPU, 4GB RAM)

- проверка созданных ресурсов

```bash
yc managed-kubernetes cluster list
yc managed-kubernetes node-group list
```

- Кластер и нод-группа успешно созданы и находятся в статусе RUNNING

![scr-23](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/yc_kuber_cluster_list.png)


- проверка ресурсов кластера через kubectl

```bash
yc managed-kubernetes cluster get-credentials k8s-cluster --external

kubectl cluster-info

kubectl get nodes -o wide

kubectl get pods --all-namespaces

```
- Успешное подключение к кластеру. 3 worker ноды готовы к работе


![scr-24](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/kubectl_cluster.png)

---

#### 10. Инициализация и деплой  Container Registry

- terraform init 

![scr-25](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_i_registry.png)

- terraform plan

![scr-26](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_p_registry.png)

- terraform apply


![scr-27](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/T_a_start_registry.png)
![scr-28](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/t_a_fin_registry.png)

- Terraform создал Container Registry devops-registry и назначил сервисному аккаунту права на pull образов

- Проверка созданных ресурсов

```bash
terraform output registry_id

yc container registry list
```

![scr-29](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/yc_registry.png)


---

#### 11. Запуск докера в Container registry

- выполнение docker build

![scr-30](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/docker_build.png)

- docker push

![scr-31](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/docker_push.png)

- Собран Docker образ на основе nginx:alpine с статической страницей. Образ запушен в Container Registry cr.yandex/crpumur24q4gj9d4dcie/devops-app:v1.0.0


---

#### 12. Деплой приложения в Kubernettes

- Деплой приложения

![scr-32](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/manifest.png)

- Проверка подов

![scr-33](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/kubectl_get_pods.png)

- Оба пода приложения в статусе Running.Сервис типа LoadBalancer получил внешний IP 158.160.237.185, приложение доступно из интернета.

- Страница приложения

![scr-34](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/web_app.png)


---

#### 13. Установка мониторинга через Helm

- Добавление репозитория и обновление Helm

![scr-35](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/helm_update.png)

- Установка мониторинга из репозитория

![scr-36](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/helm_monitoring.png)

- С помощью Helm установлен kube-prometheus-stack, включающий Prometheus, Grafana, Alertmanager и экспортеры метрик кластера

- Проверка внешнего адреса после установки

![scr-37](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/monitoring_svc.png)

- Проверка работоспособности сервиса


![scr-38](https://github.com/vladrabbit/DEVOPS-project/blob/main/SCR/grafana.png)





