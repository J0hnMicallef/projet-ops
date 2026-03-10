terraform {
  cloud {
    organization = "REMPLACE_PAR_TON_ORG"
    workspaces {
      name = "projet-ops"
    }
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}