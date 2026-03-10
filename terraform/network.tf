# ─────────────────────────────────────────────────────────────────────
# RÉSEAUX DOCKER
#
# public-net  → Bastion + HAProxy   (accessible de l'extérieur)
# private-net → HAProxy + Web Apps  (jamais exposé directement)
# db-net      → Web Apps + PostgreSQL (base de données isolée)
#
# Sur un vrai cloud ce seraient des subnets dans un VPC
# avec des route tables et security groups.
# ─────────────────────────────────────────────────────────────────────

resource "docker_network" "public" {
  name   = "${var.project_name}-public-net"
  driver = "bridge"

  ipam_config {
    subnet  = "172.20.0.0/24"
    gateway = "172.20.0.1"
  }

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "tier"
    value = "public"
  }
}

resource "docker_network" "private" {
  name   = "${var.project_name}-private-net"
  driver = "bridge"

  ipam_config {
    subnet  = "172.30.0.0/24"
    gateway = "172.30.0.1"
  }

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "tier"
    value = "private"
  }
}

resource "docker_network" "db" {
  name   = "${var.project_name}-db-net"
  driver = "bridge"

  ipam_config {
    subnet  = "172.40.0.0/24"
    gateway = "172.40.0.1"
  }

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "tier"
    value = "database"
  }
}