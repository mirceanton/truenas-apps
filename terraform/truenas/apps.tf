resource "truenas_app" "traefik" {
  name       = "traefik"
  custom_app = true
  compose_config = templatefile("${path.module}/files/traefik/compose.yaml", {
    TRAEFIK_CF_DNS_API_TOKEN     = replace(data.onepassword_item.cloudflare.password, "$", "$$")
    TRAEFIK_DASHBOARD_BASIC_AUTH = replace(local.traefik_htpasswd, "$", "$$")
  })
}

resource "truenas_app" "dozzle" {
  name       = "dozzle"
  custom_app = true
  compose_config = templatefile("${path.module}/files/dozzle/compose.yaml", {
    DOZZLE_ADMIN_USERNAME = replace(data.onepassword_item.dozzle.username, "$", "$$")
    DOZZLE_ADMIN_PASSWORD = replace(local.dozzle_htpasswd, "$", "$$")
  })
  depends_on = [truenas_app.traefik]
}

resource "truenas_app" "exporters" {
  name           = "exporters"
  custom_app     = true
  compose_config = file("${path.module}/files/exporters/compose.yaml")
}

resource "truenas_app" "garage" {
  name       = "garage"
  custom_app = true
  compose_config = templatefile("${path.module}/files/garage/compose.yml", {
    garage_config       = indent(6, file("${path.module}/files/garage/garage.toml"))
    GARAGE_RPC_SECRET   = replace(data.onepassword_item.garage_rpc.password, "$", "$$")
    GARAGE_ADMIN_TOKEN  = replace(data.onepassword_item.garage_admin.password, "$", "$$")
    GARAGE_WEBUI_ADMIN_PASS = replace(data.onepassword_item.garage_webui.password, "$", "$$")
  })
  depends_on = [truenas_app.traefik]
}

resource "truenas_app" "nexus" {
  name           = "registry"
  custom_app     = true
  compose_config = file("${path.module}/files/registry/compose.yaml")
  depends_on     = [truenas_app.traefik]
}
