# ─────────────────────────────────────────────────────────────────────
# BASE DE DONNÉES — PostgreSQL 15
#
# Connectée uniquement au réseau db-net.
# Aucun port exposé à l'extérieur : seules les web apps
# (sur le même réseau db-net) peuvent la joindre.
# ─────────────────────────────────────────────────────────────────────

resource "docker_image" "postgres" {
  name         = "postgres:15-alpine"
  keep_locally = true
}

resource "docker_volume" "postgres_data" {
  name = "${var.project_name}-postgres-data"
}

resource "docker_container" "postgres" {
  name    = "${var.project_name}-postgres"
  image   = docker_image.postgres.image_id
  restart = "unless-stopped"

  networks_advanced {
    name         = docker_network.db.name
    ipv4_address = "172.40.0.100"
    aliases      = ["postgres", "db"]
  }

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "PGDATA=/var/lib/postgresql/data/pgdata",
  ]

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U ${var.db_user} -d ${var.db_name}"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "10s"
  }

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "role"
    value = "database"
  }
}