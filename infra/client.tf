resource "keycloak_openid_client" "dbd_web" {
  realm_id            = keycloak_realm.realm.id
  client_id           = uuid()
  name                = "Day By Day - Web"
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

resource "keycloak_openid_client" "dbd_backend" {
  realm_id            = keycloak_realm.realm.id
  client_id           = uuid()
  name                = "Day By Day - Backend"
  enabled             = true

  access_type         = "CONFIDENTIAL"
  standard_flow_enabled = true
  implicit_flow_enabled = false
  direct_access_grants_enabled = true
  oauth2_device_authorization_grant_enabled = true

  # Redirect URIs
  valid_redirect_uris = [
    "http://localhost:3000/*"
  ]

  web_origins = [
    "*"
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
