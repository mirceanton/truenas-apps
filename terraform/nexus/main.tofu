terraform {
  required_providers {
    sonatyperepo = {
      source  = "sonatype-nexus-community/sonatyperepo"
      version = "1.1.0"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "3.2.1"
    }
  }
}

provider "sonatyperepo" {
  url      = var.nexus_url
  username = var.nexus_username
  password = var.nexus_password
}

data "onepassword_vault" "vault" {
  name = var.op_vault_name
}