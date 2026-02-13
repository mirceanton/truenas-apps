terraform {
  required_providers {
    sonatyperepo = {
      source  = "sonatype-nexus-community/sonatyperepo"
      version = "1.0.3"
    }
  }
}

provider "sonatyperepo" {
  url      = var.nexus_url
  username = var.nexus_username
  password = var.nexus_password
}

variable "nexus_url" {
  type = string
}
variable "nexus_username" {
  type = string
}
variable "nexus_password" {
  type = string
  sensitive = true
}
