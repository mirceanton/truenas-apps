resource "keycloak_realm" "homelab" {
  realm        = "homelab"
  enabled      = true
  display_name = "Homelab"

  registration_allowed = false

  sso_session_idle_timeout = "8h"
  sso_session_max_lifespan = "12h"
}
