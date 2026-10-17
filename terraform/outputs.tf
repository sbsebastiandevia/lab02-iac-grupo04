# outputs.tf
# Valores de salida utiles tras el despliegue.

output "container_id" {
  description = "ID del contenedor creado"
  value       = docker_container.app_container.id
}

output "container_name" {
  description = "Nombre del contenedor creado"
  value       = docker_container.app_container.name
}

output "service_url" {
  description = "URL local para acceder al servicio"
  value       = "http://localhost:${var.host_port}"
}
