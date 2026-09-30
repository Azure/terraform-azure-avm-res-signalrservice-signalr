resource "random_id" "suffix" {
  byte_length = 4
}

resource "azapi_resource" "resource_group" {
  type     = "Microsoft.Resources/resourceGroups@2024-11-01"
  name     = "rg-avm-signalr-${random_id.suffix.hex}"
  location = var.location

  response_export_values = []
}
