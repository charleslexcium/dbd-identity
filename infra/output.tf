# output "name" {
#   value = data.http.create_organization.response_body
# }

output "dbd_client_secret" {
  value = keycloak_openid_client.dbd.client_secret
  sensitive = true
}