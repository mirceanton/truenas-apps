include "root" { path = find_in_parent_folders("root.hcl") }

terraform { source = find_in_parent_folders("terraform/nexus") }
inputs = {
  nexus_url                = "https://registry.nas.svc.h.mirceanton.com"
  nexus_username           = get_env("NEXUS_USERNAME", "")
  nexus_password           = get_env("NEXUS_PASSWORD", "")
  op_service_account_token = get_env("OP_SERVICE_ACCOUNT_TOKEN", "")
  op_vault_name            = "Automation"
}