output "location" {
  description = "The Azure region in which the SignalR service was created."
  value       = azapi_resource.this.location
}

output "name" {
  description = "The name of the SignalR service."
  value       = azapi_resource.this.name
}

output "resource_id" {
  description = "The resource ID of the SignalR service."
  value       = azapi_resource.this.id
}
