terraform {
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "5.0.0"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "3.2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = var.keycloak_username
  password  = var.keycloak_password
  url       = var.keycloak_url
}

data "onepassword_vault" "vault" {
  name = var.op_vault_name
}
