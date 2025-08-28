variable "namespace" {
  type    = string
  default = "dbd"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "client_scopes" {
  type = list(object({
    name                   = string
    description            = string
    include_in_token_scope = bool
    consent_screen_text    = string
    gui_order              = number
  }))
  default = []
}
