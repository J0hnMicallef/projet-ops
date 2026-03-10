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

  # Config minimale pour démarrer — Ansible écrasera cette config
  command = [
    "sh", "-c",
    <<-CMD
      cat > /usr/local/etc/haproxy/haproxy.cfg << 'EOF'
      global
        daemon
      defaults
        mode http
        timeout connect 5s
        timeout client  30s
        timeout server  30s
      frontend http_front
        bind *:80
        default_backend web_servers
      backend web_servers
        balance roundrobin
        server web1 172.30.0.10:80 check
        server web2 172.30.0.11:80 check
      EOF
      haproxy -f /usr/local/etc/haproxy/haproxy.cfg
    CMD
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