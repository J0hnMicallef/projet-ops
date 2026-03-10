# ─────────────────────────────────────────────────────────────────────
# BASTION
#
# Seul point d'entrée SSH vers l'infrastructure.
# Sur un vrai cloud, il serait dans le subnet public avec une IP
# publique. Les autres serveurs n'auraient PAS d'IP publique
# et seraient uniquement joignables via le bastion (SSH jump).
#
# Connecté uniquement au réseau public.
# ─────────────────────────────────────────────────────────────────────

resource "docker_image" "bastion" {
  name         = "rastasheep/ubuntu-sshd:18.04"
  keep_locally = true
}

resource "docker_container" "bastion" {
  name    = "${var.project_name}-bastion"
  image   = docker_image.bastion.image_id
  restart = "unless-stopped"

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