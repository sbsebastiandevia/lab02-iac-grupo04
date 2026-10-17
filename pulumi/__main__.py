"""Infraestructura del Lab 02 definida con Pulumi (Python).

Despliega la misma infraestructura que el modulo de Terraform, para permitir
una comparacion equivalente entre ambas herramientas:
  1. Una red Docker dedicada.
  2. La imagen de Docker.
  3. El contenedor de la aplicacion, conectado a la red y con el puerto
     publicado al host.
"""
import pulumi
import pulumi_docker as docker

# Configuracion del stack (valores en Pulumi.<stack>.yaml).
config = pulumi.Config()
app_name = config.get("app_name") or "webapp"
group_id = config.get("group_id") or "grupo04"
environment = config.get("environment") or "dev"
host_port = config.get_int("host_port") or 8080
image_name = config.get("image_name") or "nginx:1.27-alpine"

# 1. Red Docker dedicada.
network = docker.Network("app_network", name=f"{app_name}-{group_id}-net")

# 2. Imagen de Docker (se mantiene en el cache local).
image = docker.RemoteImage(
    "app_image",
    name=image_name,
    keep_locally=True,
)

# 3. Contenedor de la aplicacion.
container = docker.Container(
    "app_container",
    name=f"{app_name}-{group_id}-{environment}",
    image=image.image_id,
    networks_advanced=[docker.ContainerNetworksAdvancedArgs(name=network.name)],
    ports=[docker.ContainerPortArgs(internal=80, external=host_port)],
    restart="unless-stopped",
    labels=[
        docker.ContainerLabelArgs(label="environment", value=environment),
        docker.ContainerLabelArgs(label="managed_by", value="pulumi"),
    ],
)

# Outputs equivalentes a los de Terraform.
pulumi.export("container_id", container.id)
pulumi.export("container_name", container.name)
pulumi.export("service_url", f"http://localhost:{host_port}")
