resource "docker_network" "main" {
  name = "${var.project_name}-network"
}