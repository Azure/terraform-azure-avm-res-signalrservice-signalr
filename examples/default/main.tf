resource "random_id" "suffix" {
  byte_length = 4
}

resource "azapi_resource" "resource_group" {
  location               = var.location
  name                   = "rg-avm-signalr-${random_id.suffix.hex}"
  type                   = "Microsoft.Resources/resourceGroups@2024-11-01"
  response_export_values = []
}

module "signalr" {
  source = "../../"

  location         = var.location
  name             = "sigr-avm-${random_id.suffix.hex}"
  parent_id        = azapi_resource.resource_group.id
  enable_telemetry = var.enable_telemetry
}
