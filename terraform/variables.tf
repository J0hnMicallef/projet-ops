variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "db_password" {
  description = "Mot de passe PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nom de la base de données"
  type        = string
}

variable "db_user" {
  description = "Utilisateur PostgreSQL"
  type        = string
}

variable "web_count" {
  description = "Nombre de serveurs web"
  type        = number
  default     = 2
}

variable "haproxy_port" {
  description = "Port exposé pour HAProxy (entrée HTTP)"
  type        = number
  default     = 80
}

variable "bastion_port" {
  description = "Port SSH exposé pour le bastion"
  type        = number
  default     = 2222
}