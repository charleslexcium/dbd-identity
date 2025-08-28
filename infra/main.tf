locals {
  roles = [
    {
      name        = "customer"
      description = "Customer"
    }
  ]

  groups = [
    {
      name        = "customer"
      description = "Customers"
      roles      = ["customer"]
    }
  ]
}

resource "keycloak_realm" "realm" {
  realm             = "dbd"
  enabled           = true
  display_name      = "Day By Day"
  display_name_html = "<b>Day By Day</b>"

  organizations_enabled = true

  ssl_required    = "external"
  password_policy = "upperCase(1) and length(8) and forceExpiredPasswordChange(365) and notUsername"

  smtp_server {
    host = "mailpit"
    port = 1025
    from = "customerexperience@dbd.com"

    auth {
      username = "tom"
      password = "password"
    }

    from_display_name     = "Folks @ dbd"
    reply_to_display_name = "Folks @ dbd"
    reply_to              = "info@dbd.io"
    ssl                   = false
    starttls              = true
    envelope_from         = "info@dbd.com"
  }

  account_theme = "base"

  access_code_lifespan                    = "5m"
  access_code_lifespan_login              = "30m0s"
  access_code_lifespan_user_action        = "5m0s"
  access_token_lifespan                   = "5m0s"
  access_token_lifespan_for_implicit_flow = "15m0s"

  action_token_generated_by_admin_lifespan = "12h0m0s"
  action_token_generated_by_user_lifespan  = "5m0s"

  browser_flow                   = "browser"
  client_authentication_flow     = "clients"
  client_session_idle_timeout    = "0s"
  client_session_max_lifespan    = "0s"
  default_default_client_scopes  = []
  default_optional_client_scopes = []
  default_signature_algorithm    = "RS256"
  direct_grant_flow              = "direct grant"

  duplicate_emails_allowed = false
  edit_username_allowed    = false
  email_theme              = null

  login_theme                          = "base"
  login_with_email_allowed             = true
  oauth2_device_code_lifespan          = "10m0s"
  oauth2_device_polling_interval       = 5
  offline_session_idle_timeout         = "720h0m0s"
  offline_session_max_lifespan         = "1440h0m0s"
  offline_session_max_lifespan_enabled = false

  # password_policy = "upperCase(1) and length(8) and forceExpiredPasswordChange(365) and notUsername"

  refresh_token_max_reuse              = 0
  registration_allowed                 = true
  registration_email_as_username       = true
  registration_flow                    = "registration"
  remember_me                          = true
  reset_credentials_flow               = "reset credentials"
  reset_password_allowed               = true
  revoke_refresh_token                 = false
  sso_session_idle_timeout             = "30m0s"
  sso_session_idle_timeout_remember_me = "0s"
  sso_session_max_lifespan             = "10h0m0s"
  sso_session_max_lifespan_remember_me = "0s"
  user_managed_access                  = false
  verify_email                         = true

  internationalization {
    supported_locales = [
      "en",
    ]

    default_locale = "en"
  }

  security_defenses {
    headers {
      x_frame_options                     = "DENY"
      content_security_policy             = "frame-src 'self'; frame-ancestors 'self'; object-src 'none';"
      content_security_policy_report_only = ""
      x_content_type_options              = "nosniff"
      x_robots_tag                        = "none"
      x_xss_protection                    = "1; mode=block"
      strict_transport_security           = "max-age=31536000; includeSubDomains"
    }

    brute_force_detection {
      permanent_lockout                = false
      max_login_failures               = 31
      wait_increment_seconds           = 61
      quick_login_check_milli_seconds  = 1000
      minimum_quick_login_wait_seconds = 120
      max_failure_wait_seconds         = 900
      failure_reset_time_seconds       = 43200
    }
  }

  otp_policy {
    algorithm         = "HmacSHA1"
    digits            = 6
    initial_counter   = 0
    look_ahead_window = 1
    period            = 30
    type              = "totp"
  }

  attributes = {
    namespace   = var.namespace
    environment = var.environment
  }

  web_authn_policy {
    relying_party_entity_name = "keycloak"
    relying_party_id          = "dev.neithing.com"
    signature_algorithms = [
      "ES256",
      "RS256"
    ]
  }

  web_authn_passwordless_policy {
    relying_party_entity_name = "keycloak"
    relying_party_id          = "dev.neithing.com"
    signature_algorithms = [
      "ES256",
      "RS256"
    ]
  }

}

resource "keycloak_user" "user_with_initial_password" {
  realm_id = keycloak_realm.realm.id
  enabled  = true

  username   = "sadmin@dbd.com"
  email      = "sadmin@dbd.com"
  first_name = "Super"
  last_name  = "Admin"

  email_verified = true

  attributes = {
    role = "superadmin"
  }

  initial_password {
    value     = "s0m3pAssw0rd"
    temporary = true
  }

  required_actions = [
    "UPDATE_PASSWORD",
  ]
}

resource "keycloak_group" "groups" {
  for_each = { for group in local.groups : group.name => group }

  realm_id = keycloak_realm.realm.id
  name     = each.value.name

  attributes = {
    description = each.value.description
  }
}

resource "keycloak_role" "roles" {
  for_each = { for role in local.roles : role.name => role }

  realm_id    = keycloak_realm.realm.id
  name        = each.value.name
  description = each.value.description
}

resource "keycloak_group_roles" "group_roles" {
  for_each = { for group in local.groups : group.name => group }

  realm_id = keycloak_realm.realm.id
  group_id = keycloak_group.groups[each.key].id

  role_ids = toset([for role in keycloak_role.roles : role.id if contains(each.value.roles, role.name)])

  depends_on = [keycloak_role.roles]
}

# https://phasetwo.io/docs/audit-logs/webhooks/
# https://github.com/p2-inc/keycloak-events?tab=readme-ov-file#webhooks
resource "keycloak_realm_events" "realm_events" {
  realm_id = keycloak_realm.realm.id

  events_enabled    = true
  events_expiration = 3600

  admin_events_enabled         = true
  admin_events_details_enabled = true

  # When omitted or left empty, keycloak will enable all event types
  enabled_event_types = []

  events_listeners = [
    "jboss-logging",
    "ext-event-http"
  ]
}