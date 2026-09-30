variable "location" {
  type        = string
  description = "The Azure region in which the SignalR service will be created."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the SignalR service."
  nullable    = false

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9-]{1,61}[A-Za-z0-9]$", var.name))
    error_message = "`name` must be 3 to 63 characters, start with a letter, end with a letter or number, and contain only letters, numbers, and hyphens."
  }
}

variable "parent_id" {
  type        = string
  description = "The fully-qualified resource ID of the resource group in which the SignalR service will be created."
  nullable    = false

  validation {
    condition     = can(provider::azapi::parse_resource_id("Microsoft.Resources/resourceGroups", var.parent_id))
    error_message = "`parent_id` must be a valid resource group resource ID."
  }
}

variable "allowed_origins" {
  type        = set(string)
  default     = ["*"]
  description = "The origins allowed to make cross-origin requests to the SignalR service."
  nullable    = false
}

variable "disable_aad_auth" {
  type        = bool
  default     = false
  description = "Whether Microsoft Entra ID authentication is disabled for the SignalR service."
  nullable    = false
}

variable "disable_local_auth" {
  type        = bool
  default     = true
  description = "Whether access-key authentication is disabled for the SignalR service."
  nullable    = false
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "features" {
  type = list(object({
    flag       = string
    value      = string
    properties = optional(map(string))
  }))
  default = [
    {
      flag  = "ServiceMode"
      value = "Serverless"
    }
  ]
  description = <<DESCRIPTION
Feature settings for the SignalR service.

- `flag` - The feature flag name.
- `value` - The feature flag value.
- `properties` - (Optional) Additional feature properties.
DESCRIPTION
  nullable    = false

  validation {
    condition = alltrue([
      for feature in var.features :
      length(feature.flag) > 0 && length(feature.value) >= 1 && length(feature.value) <= 128
    ])
    error_message = "Each feature must have a non-empty `flag` and a `value` containing 1 to 128 characters."
  }
}

variable "ignore_body_changes" {
  type = object({
    signalrservice_signal_r = optional(list(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
Body-relative paths to ignore for each AzAPI resource. Paths use dot notation. Changes take effect only after apply, and configuration for an ignored path is not sent to Azure until the path is removed. Individual list indices cannot be targeted.

- `signalrservice_signal_r` - Paths ignored on the SignalR service resource.
DESCRIPTION
  nullable    = false
}

variable "kind" {
  type        = string
  default     = "SignalR"
  description = "The kind of SignalR service to create."
  nullable    = false

  validation {
    condition     = contains(["SignalR", "RawWebSockets"], var.kind)
    error_message = "`kind` must be either `SignalR` or `RawWebSockets`."
  }
}

variable "resource_types" {
  type = object({
    signalrservice_signal_r = optional(string, "Microsoft.SignalRService/signalR@2024-03-01")
  })
  default     = {}
  description = <<DESCRIPTION
AzAPI resource types and API versions used by the module.

- `signalrservice_signal_r` - Resource type and API version for the SignalR service.
DESCRIPTION
  nullable    = false
}

variable "retry" {
  type = object({
    error_message_regex  = optional(list(string))
    interval_seconds     = optional(number)
    max_interval_seconds = optional(number)
  })
  default     = null
  description = <<DESCRIPTION
Retry configuration applied to every supported AzAPI resource declared by the module. Defaults to `null` (no custom retry).

- `error_message_regex` - (Optional) A list of regular expression patterns matching error messages that trigger a retry.
- `interval_seconds` - (Optional) The initial interval between retries in seconds.
- `max_interval_seconds` - (Optional) The maximum interval between retries in seconds.

See <https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource#retry> for full semantics.
DESCRIPTION
}

variable "sku" {
  type = object({
    name     = optional(string, "Standard_S1")
    tier     = optional(string)
    capacity = optional(number, 1)
  })
  default     = {}
  description = <<DESCRIPTION
The SKU configuration for the SignalR service.

- `name` - (Optional) The SKU name. Supported values are `Free_F1`, `Standard_S1`, `Standard_S2`, `Standard_S3`, `Premium_P1`, `Premium_P2`, and `Premium_P3`. Defaults to `Standard_S1`.
- `tier` - (Optional) The SKU tier. When omitted, the module derives `Free`, `Standard`, or `Premium` from `name`.
- `capacity` - (Optional) The unit count for the SKU. Defaults to `1`.
DESCRIPTION
  nullable    = false

  validation {
    condition = contains([
      "Free_F1",
      "Standard_S1",
      "Standard_S2",
      "Standard_S3",
      "Premium_P1",
      "Premium_P2",
      "Premium_P3",
    ], var.sku.name)
    error_message = "`sku.name` must be a supported SignalR SKU."
  }
  validation {
    condition     = var.sku.tier == null || contains(["Free", "Standard", "Premium"], var.sku.tier)
    error_message = "`sku.tier` must be `Free`, `Standard`, `Premium`, or null."
  }
  validation {
    condition     = var.sku.capacity > 0 && floor(var.sku.capacity) == var.sku.capacity
    error_message = "`sku.capacity` must be a positive whole number."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A map of tags to assign to the SignalR service."
}

variable "timeouts" {
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Per-operation timeouts applied to every supported AzAPI resource declared by the module. Defaults to `null` (provider defaults). Each value is a Go duration string such as `30m` or `1h`.

- `create` - (Optional) Timeout for create operations.
- `read` - (Optional) Timeout for read operations.
- `update` - (Optional) Timeout for update operations.
- `delete` - (Optional) Timeout for delete operations.
DESCRIPTION
}
