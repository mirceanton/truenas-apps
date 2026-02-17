data "onepassword_vault" "vault" {
  name = var.op_vault_name
}

# --- Dozzle ---
data "onepassword_item" "dozzle" {
  vault = data.onepassword_vault.vault.uuid
  title = "Dozzle"
}

# --- Garage ---
data "onepassword_item" "garage_rpc" {
  vault = data.onepassword_vault.vault.uuid
  title = "Garage RPC Secret"
}

data "onepassword_item" "garage_admin" {
  vault = data.onepassword_vault.vault.uuid
  title = "Garage Admin Token"
}

data "onepassword_item" "garage_webui" {
  vault = data.onepassword_vault.vault.uuid
  title = "Garage WebUI"
}

# --- Traefik ---
data "onepassword_item" "cloudflare" {
  vault = data.onepassword_vault.vault.uuid
  title = "Cloudflare API Token"
}

data "onepassword_item" "traefik_dashboard" {
  vault = data.onepassword_vault.vault.uuid
  title = "Traefik Dashboard"
}

locals {
  traefik_htpasswd = one([
    for f in flatten([for s in data.onepassword_item.traefik_dashboard.section : s.field]) :
    f.value if f.label == "htpasswd"
  ])
  dozzle_htpasswd = one([
    for f in flatten([for s in data.onepassword_item.dozzle.section : s.field]) :
    f.value if f.label == "htpasswd"
  ])
}
