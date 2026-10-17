# providers.tf
# Conexion al Docker Engine local a traves de su socket Unix.
# En Linux/macOS el socket por defecto es unix:///var/run/docker.sock

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
