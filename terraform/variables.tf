# variables.tf
# Variables de entrada del modulo. Permiten parametrizar el despliegue
# sin tocar la logica principal (main.tf).

variable "app_name" {
  description = "Nombre base de la aplicacion / contenedor"
  type        = string
  default     = "webapp"
}

variable "group_id" {
  description = "Identificador del grupo de trabajo"
  type        = string
  default     = "grupo04"
}

variable "environment" {
  description = "Ambiente de despliegue (dev, stg, prod)"
  type        = string
  default     = "dev"
}

variable "host_port" {
  description = "Puerto del host que se mapea al puerto 80 del contenedor"
  type        = number
  default     = 8080
}

variable "image_name" {
  description = "Imagen de Docker a desplegar"
  type        = string
  default     = "nginx:1.27-alpine"
}
