##Подключение провайдера (Это зеркало!)
terraform {
  required_providers {
    yandex = {
      source  = "registry.tfpla.net/yandex-cloud/yandex"
      version = "0.88.0"
    }
  }
##Хран для state
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "state-bucket-itsorokin"
    region     = "ru-central1-a"
    key        = "issue1/lemp.tfstate"
    access_key = "****************************"
    secret_key = "***********************************"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

##Определяю зону облака
locals {
  zone_a = "ru-central1-a"
}

##Подключение к провайдеру
provider "yandex" {
  token     = "******************************"
  cloud_id  = "********************"
  folder_id = "********************"
}

##Сеть
resource "yandex_vpc_network" "mynetwork-001" {
  name = "mynetwork-001"
}

##Подсеть
resource "yandex_vpc_subnet" "subnet01" {
  name           = "subnet01"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.mynetwork-001.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

##Образ для машины
data "yandex_compute_image" "centos_image" {
  family = "centos-7"
}

##Конфигурация машины
resource "yandex_compute_instance" "docker_pgsql" {
  name = "docker-pgsql"
  zone = local.zone_a
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20 #использование CPU
  }

  scheduling_policy { #прерываемая машина
    preemptible = true
  }
### Диск для ВМ
  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.centos_image.id
      type        = "network-hdd" # тип загрузочного носителя (network-hdd | network-ssd);
      size        = 20             # размер диска, ГБ (меньше 5 ГБ выбрать нельзя);
      description = "CENTOS"
    }
  }
## Подключаем интерфейс 
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet01.id
    nat       = true
  }
### Передаю SSH для доступа  
  metadata = {
    serial-port-enable = 1
    #ssh-keys = "vinkin:${file("~/.ssh/mykey.pub")}"
    user-data          = "${file("meta.yml")}"
  }
}