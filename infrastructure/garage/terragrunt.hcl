include "root" { path = find_in_parent_folders("root.hcl") }

terraform { source = find_in_parent_folders("terraform/garage") }
inputs = {
  garage_url               = "https://garage-admin.nas.svc.h.mirceanton.com"
  garage_token             = get_env("GARAGE_TOKEN", "")
  op_service_account_token = get_env("OP_SERVICE_ACCOUNT_TOKEN", "")
  op_vault_name            = "Automation"
}