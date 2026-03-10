resource "docker_image" "bastion" {
  name         = "ubuntu:22.04"
  keep_locally = true
}

resource "docker_container" "bastion" {
  name    = "${var.project_name}-bastion"
  image   = docker_image.bastion.image_id
  restart = "unless-stopped"

  # Garder le conteneur actif
  entrypoint = ["/bin/bash", "-c"]
  command    = ["apt-get update -qq && apt-get install -y openssh-server -qq && service ssh start && tail -f /dev/null"]

  networks_advanced {
    name         = docker_network.public.name
    ipv4_address = "172.20.0.10"
    aliases      = ["bastion"]
  }

  ports {
    internal = 22
    external = var.bastion_port
  }

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "role"
    value = "bastion"
  }
}