terraform {
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "~>5.2"
    }
  }
}

provider "keycloak" {
  client_id     = "admin-cli"
  username      = "admin"
  password      = "adminpassword"
  url           = "http://localhost:80"
}
