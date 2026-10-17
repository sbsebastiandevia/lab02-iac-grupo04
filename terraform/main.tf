# main.tf
# Recursos principales de la infraestructura local:
#   1. Una red Docker dedicada.
#   2. La imagen de Docker (descargada si no existe localmente).
#   3. El contenedor que ejecuta la aplicacion, conectado a la red.

# 1. Red Docker dedicada para la aplicacion.
resource "docker_network" "app_network" {
  name = "${var.app_name}-${var.group_id}-net"
}

# 2. Imagen de Docker. keep_locally evita que Terraform borre la imagen
#    del cache local al hacer destroy.
resource "docker_image" "app_image" {
  name         = var.image_name
  keep_locally = true
}

# 3. Contenedor de la aplicacion.
resource "docker_container" "app_container" {
  name  = "${var.app_name}-${var.group_id}-${var.environment}"
  image = docker_image.app_image.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 80
    external = var.host_port
  }

  restart = "unless-stopped"

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "managed_by"
    value = "terraform"
  }
}
