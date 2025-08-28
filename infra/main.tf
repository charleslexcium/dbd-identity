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
  registration_allowed  = true
  # registration_email_as_username = true
  # login_with_email_allowed = true
  # duplicate_emails_allowed = false
  # reset_password_allowed = true
  # verify_email = true

  login_theme = "base"

  access_code_lifespan = "1h"

  ssl_required    = "external"
  password_policy = "upperCase(1) and length(8) and forceExpiredPasswordChange(365) and notUsername"
  attributes      = {
    mycustomAttribute = "myCustomValue"
  }

  smtp_server {
    host = "mailpit"
    port = 1025
    from = "customerexperience@dbd.com"

    auth {
      username = "tom"
      password = "password"
    }
  }

  internationalization {
    supported_locales = [
      "en",
    ]
    default_locale    = "en"
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
      permanent_lockout                 = false
      max_login_failures                = 30
      wait_increment_seconds            = 60
      quick_login_check_milli_seconds   = 1000
      minimum_quick_login_wait_seconds  = 60
      max_failure_wait_seconds          = 900
      failure_reset_time_seconds        = 43200
    }
  }

  web_authn_policy {
    relying_party_entity_name = "example"
    relying_party_id          = "dbd.com"
    signature_algorithms      = ["ES256", "RS256"]
  }
}

resource "keycloak_user" "user_with_initial_password" {
  realm_id = keycloak_realm.realm.id
  enabled  = true

  username   = "sadmin"
  email      = "sadmin@dbd.com"
  first_name = "Super"
  last_name  = "Admin"

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