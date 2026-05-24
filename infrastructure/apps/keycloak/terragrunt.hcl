include "root" { path = find_in_parent_folders("root.hcl") }

terraform { source = find_in_parent_folders("terraform/keycloak") }

inputs = {
  keycloak_url      = "https://keycloak.nas.svc.h.mirceanton.com"
  keycloak_username = get_env("KEYCLOAK_ADMIN_USERNAME", "")
  keycloak_password = get_env("KEYCLOAK_ADMIN_PASSWORD", "")
  op_vault_name     = "Automation"
}
