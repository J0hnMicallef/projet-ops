terraform {
  cloud {
    organization = "projet-ops"
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

provider "docker" {}