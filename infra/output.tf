# output "name" {
#   value = data.http.create_organization.response_body
# }

output "dbd_backend_client_id" {
  value = keycloak_openid_client.dbd_backend.client_id
}
output "dbd_backend_client_secret" {
  value     = keycloak_openid_client.dbd_backend.client_secret
  sensitive = true
}

output "dbd_web_client_id" {
  value = keycloak_openid_client.dbd_web.client_id
}

output "dbd_web_client_secret" {
  value     = keycloak_openid_client.dbd_web.client_secret
  sensitive = true
}
