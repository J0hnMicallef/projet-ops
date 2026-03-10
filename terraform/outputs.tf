output "bastion" {
  description = "Accès SSH au bastion"
  value       = "ssh root@localhost -p ${var.bastion_port}"
}

output "haproxy_url" {
  description = "URL du load balancer"
  value       = "http://localhost:${var.haproxy_port}"
}

output "web_servers" {
  description = "Serveurs web (accessibles uniquement via HAProxy)"
  value = [
    for i in range(var.web_count) :
    "172.30.0.${10 + i} (${var.project_name}-web${i + 1})"
  ]
}

output "database" {
  description = "PostgreSQL (accessible uniquement depuis le réseau db)"
  value       = "172.40.0.100:5432 — db: ${var.db_name} — user: ${var.db_user}"
}

output "networks" {
  description = "Réseaux créés"
  value = {
    public  = "172.20.0.0/24 (bastion + haproxy)"
    private = "172.30.0.0/24 (haproxy + web apps)"
    db      = "172.40.0.0/24 (web apps + postgresql)"
  }
}