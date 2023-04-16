# make_b7_project
Проектная работа 7

Собираем образ:
 docker build ./ --no-cache -t python01:mypy

Запусать docker командой:
  docker run -d --network=host -v /srv/app:/app/ python01:mypy
  
В каталоге terraform конфигурация создания машины на Яндекс облаке
В каталоге ansible конфигурация установки и настройки сервера
В каталоге docker находится Dockerfile и файл для установки из pip
В каталоге app конфигурации для выполнения работы

В ansible столкнулся проблемой создания базы в postgresql. Хотел применить следующий модуль:
  - name: Create db
    community.postgresql.postgresql_db:
            state: present
            name: b7database
                    
  - name: Connect to database and add user
    community.postgresql.postgresql_user:
          db: b7database
          name: dbuser
          password: 123psk
          priv: "CONNECT/products:ALL"

НО так как у меня хостовая машина Centos 7 максимально доступная версия  ansible 2.9, а для этого модуля нужна версия не ниже 2.11