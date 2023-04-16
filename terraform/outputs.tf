##Передаём внутренний адрес для docker_pgsql
output "internal_ip_address_docker_pgsql" {
  value = yandex_compute_instance.docker_pgsql.network_interface.0.ip_address
}

##Передаём Внешний адрес для docker_pgsql
output "external_ip_address_docker_pgsql" {
  value = yandex_compute_instance.docker_pgsql.network_interface.0.nat_ip_address
}
