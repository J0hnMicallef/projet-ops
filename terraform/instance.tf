resource "docker_image" "server" {
  name         = var.container_image
  keep_locally = true
}

resource "docker_container" "server" {
  name    = "${var.project_name}-server"
  image   = docker_image.server.image_id
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.main.name
  }

  ports {
    internal = 80
    external = var.http_port
  }

  command = ["apache2-foreground"]

  labels {
    label = "project"
    value = var.project_name
  }
}

output "container_name" {
  value = docker_container.server.name
}

output "site_url" {
  value = "http://localhost:${var.http_port}"
}