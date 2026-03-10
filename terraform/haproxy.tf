# ─────────────────────────────────────────────────────────────────────
# HAPROXY — Load Balancer
#
# Reçoit tout le trafic HTTP (port 80) et le répartit
# en round-robin entre les serveurs web.
#
# Connecté à deux réseaux :
#   - public-net  → reçoit les requêtes entrantes
#   - private-net → atteint les web apps
# ─────────────────────────────────────────────────────────────────────

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

  entrypoint = ["/bin/sh", "-c"]
  command = [
    "echo 'global\\n  daemon\\ndefaults\\n  mode http\\n  timeout connect 5s\\n  timeout client 30s\\n  timeout server 30s\\nfrontend http_front\\n  bind *:80\\n  default_backend web_servers\\nbackend web_servers\\n  balance roundrobin\\n  server web1 172.30.0.10:80 check\\n  server web2 172.30.0.11:80 check' > /usr/local/etc/haproxy/haproxy.cfg && haproxy -f /usr/local/etc/haproxy/haproxy.cfg -W"
  ]

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "role"
    value = "haproxy"
  }
}