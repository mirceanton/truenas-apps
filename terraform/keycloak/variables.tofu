variable "keycloak_url" {
  type = string
}

variable "keycloak_username" {
  type = string
}

variable "keycloak_password" {
  type      = string
  sensitive = true
}

variable "op_vault_name" {
  type    = string
  default = "Automation"
}
