variable "usr_to_roles" {
  description = "map GCP IAM roles list to a user"
  type        = map(list(string))
}

variable "custom_roles" {
  description = "Custom roles to create. "
  type = map(object({
    description      = string
    permissions      = optional(list(string), [])
    permissions_file = optional(string, null)
  }))
}

variable "org_id" {
  description = "GCP Organization ID. By default valuse is taken from cloud.hcl file"
  type        = string
}

variable "projects_billing_alerts" {
  description = "Use this to set per project billing different than `default_budget` if no notification_channels_email is provided, alerts would be send only to `default_notification_channele_email`"
  type = map(object({
    budget = object({
      amount       = number
      display_name = string
      tresholds    = list(number)
    })
    notification_channels_email = optional(list(object({
      email        = string
      display_name = string
    })), [])
  }))
}

variable "billing_account" {
  description = "Organization billing account ID"
  type        = string
}

variable "default_notification_channels_email" {
  description = "List emails to send all billing alerts to"
  type = list(object({
    email        = string
    display_name = string
  }))
}

variable "default_budget" {
  description = "Default budget for all projects to set if `projects_billing_alerts` is not provided for a project"
  type = object({
    amount       = number
    display_name = string
    tresholds    = list(number)
  })
}
