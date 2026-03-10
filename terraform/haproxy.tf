resource "docker_image" "haproxy" {
  name         = "haproxy:2.8-alpine"
  keep_locally = true
}

resource "docker_container" "haproxy" {
  name    = "${var.project_name}-haproxy"
  image   = docker_image.haproxy.image_id
  restart = "unless-stopped"

  depends_on = [docker_container.webapp]

  networks_advanced {
    name         = docker_network.public.name
    ipv4_address = "172.20.0.20"
    aliases      = ["haproxy", "lb"]
  }

  networks_advanced {
    name         = docker_network.private.name
    ipv4_address = "172.30.0.20"
  }

  ports {
    internal = 80
    external = var.haproxy_port
  }

  # Le fichier haproxy.cfg est écrit sur le runner par le pipeline
  # avant terraform apply, puis monté ici
  volumes {
    host_path      = "/tmp/haproxy.cfg"
    container_path = "/usr/local/etc/haproxy/haproxy.cfg"
    read_only      = true
  }

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "role"
    value = "haproxy"
  }
}