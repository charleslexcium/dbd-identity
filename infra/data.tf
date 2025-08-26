# data "http" "create_organization" {
# #   url = "http://localhost:9090/ping"
#   url = "http://localhost:8080/admin/realms/dbd/organizations"

#   method = "GET"

#   request_body = jsonencode({
#     name        = "staff"
#     description = "staff"
#   })

#   request_headers = {
#     Authorization = "Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI0Q2R2cUx4X3VOTFRXSVdhazJTekZmOWNwR1RnNUJZdlQzcnVhYUJ0elZnIn0.eyJleHAiOjE3NDc5ODI5MjgsImlhdCI6MTc0Nzk4MjYyOCwianRpIjoib25sdHJvOmM0YmNjY2NmLWIyNWItNGJlYS1hZTI3LWI3OTY1Mzk3YzkxYyIsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9yZWFsbXMvbWllcmV6aS11c2EiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhZG1pbi1jbGkiLCJzaWQiOiI3Y2VkYzU0My0wYWJiLTQ4NjEtYmE2ZC05M2Y1NGZmYmRhOGMiLCJzY29wZSI6InByb2ZpbGUgZW1haWwifQ.fiVTLgU_TyOY5xHdsLZD7mzhE0sjraqboxHIxVk63wYtHKCVCpGupLcg2ko6gcVhfQpjZR8Npy1pzotK4_V2RCKpGFW_ovEWh1uu_1LLZ9XGS5FcM55qwd3x1OyjrzWk97l93DwCaxfxcqSXagwNEBnbcYOK6nPCsMJ258xdJh31ZDkxYkaAeOnfFKX2E0tdRfOuA79hOb5cwtGkwH0aMgDw2gGd2bgopnt21DfSzRgmHcHoOQiP9zOLo1XdrvjhPYIEadO2WqvLXjCPivHfRcYcWNSLDH4FSsBAjLKOFC18U7hiA07AckcVjHVqbqvDNHbdF__6mti5fZUscFPoPQ"
#     Accept = "application/json"
#   }
# }


# resource "null_resource" "example" {
#   provisioner "local-exec" {
#     command = contains([200], data.http.create_organization.status_code)
#   }
# }