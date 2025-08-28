resource "keycloak_openid_client" "dbd" {
  realm_id            = keycloak_realm.realm.id
  client_id           = "dbd"
  name                = "Day By Day"
  enabled             = true

  access_type         = "CONFIDENTIAL"
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