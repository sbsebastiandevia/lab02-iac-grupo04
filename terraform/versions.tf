# versions.tf
# Declaracion de la version de Terraform y del provider de Docker.
# Se usa el provider kreuzwerker/docker, estandar de facto para gestionar
# el Docker Engine local desde Terraform.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}
