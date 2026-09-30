output "location" {
  value       = azapi_resource.resource_group.location
  description = "The Azure region in which the integration test resource group was created."
}

output "resource_group_id" {
  value       = azapi_resource.resource_group.id
  description = "The resource ID of the integration test resource group."
}

output "resource_group_name" {
  value       = azapi_resource.resource_group.name
  description = "The name of the integration test resource group."
}
