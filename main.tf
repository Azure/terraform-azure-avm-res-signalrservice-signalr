resource "azapi_resource" "this" {
  location  = var.location
  name      = var.name
  parent_id = var.parent_id
  type      = var.resource_types.signalrservice_signal_r
  body = {
    kind = var.kind
    sku = {
      name     = var.sku.name
      tier     = local.sku_tier
      capacity = var.sku.capacity
    }
    properties = {
      cors = {
        allowedOrigins = var.allowed_origins
      }
      disableAadAuth   = var.disable_aad_auth
      disableLocalAuth = var.disable_local_auth
      features = [
        for feature in var.features : merge(
          {
            flag  = feature.flag
            value = feature.value
          },
          feature.properties == null ? {} : {
            properties = feature.properties
          }
        )
      ]
    }
  }
  ignore_body_changes    = length(var.ignore_body_changes.signalrservice_signal_r) > 0 ? var.ignore_body_changes.signalrservice_signal_r : null
  response_export_values = []
  retry                  = var.retry
  tags                   = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}
