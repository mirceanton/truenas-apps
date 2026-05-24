resource "keycloak_group" "admins" {
  realm_id = keycloak_realm.homelab.id
  name     = "admins"
}

resource "keycloak_group" "users" {
  realm_id = keycloak_realm.homelab.id
  name     = "users"
}
