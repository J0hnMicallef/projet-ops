variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "http_port" {
  description = "Port HTTP exposé sur la machine hôte"
  type        = number
}

variable "container_image" {
  description = "Image Docker utilisée pour le serveur"
  type        = string
}