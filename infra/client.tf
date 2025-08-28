resource "keycloak_openid_client" "dbd" {
  realm_id            = keycloak_realm.realm.id
  client_id           = "dbd"
  name                = "Day By Day"
  enabled             = true

  access_type         = "PUBLIC"
  standard_flow_enabled = true
  implicit_flow_enabled = false

  # Redirect URIs
  valid_redirect_uris = [
    "http://localhost:3000/*"
  ]

  web_origins = [
    "http://localhost:3000"
  ]
}

resource "keycloak_openid_client_scope" "this" {
  for_each = { for t in var.client_scopes : t.name => t }

  realm_id               = keycloak_realm.realm.id
  name                   = each.value.name
  description            = each.value.description
  include_in_token_scope = each.value.include_in_token_scope
  consent_screen_text    = each.value.consent_screen_text
  gui_order              = each.value.gui_order
}
