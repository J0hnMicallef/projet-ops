# ─────────────────────────────────────────────────────────────────────
# SERVEURS WEB — 2 instances Apache + PHP
#
# Connectés à deux réseaux :
#   - private-net → reçoivent le trafic depuis HAProxy
#   - db-net      → peuvent joindre PostgreSQL
#
# Aucun port exposé directement : tout passe par HAProxy.
# ─────────────────────────────────────────────────────────────────────

resource "docker_image" "webapp" {
  name         = "php:8.2-apache"
  keep_locally = true
}

resource "docker_container" "webapp" {
  count   = var.web_count
  name    = "${var.project_name}-web${count.index + 1}"
  image   = docker_image.webapp.image_id
  restart = "unless-stopped"

  networks_advanced {
    name         = docker_network.private.name
    ipv4_address = "172.30.0.${10 + count.index}"
    aliases      = ["web${count.index + 1}"]
  }

  networks_advanced {
    name         = docker_network.db.name
    ipv4_address = "172.40.0.${10 + count.index}"
  }

  env = [
    "SERVER_ID=web${count.index + 1}",
  ]

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "role"
    value = "webapp"
  }
}