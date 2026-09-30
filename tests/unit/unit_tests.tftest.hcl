mock_provider "azapi" {}
mock_provider "modtm" {}
mock_provider "random" {}

variables {
  location  = "westus3"
  name      = "sigr-avm-phase1-test"
  parent_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-avm-signalr-test"
  tags = {
    environment = "test"
  }
}

run "creates_signalr_with_defaults" {
  command = apply

  assert {
    condition     = azapi_resource.this.type == "Microsoft.SignalRService/signalR@2024-03-01"
    error_message = "The module must deploy the expected SignalR API version."
  }

  assert {
    condition     = azapi_resource.this.parent_id == var.parent_id
    error_message = "The SignalR parent ID must match the module input."
  }

  assert {
    condition     = azapi_resource.this.body.kind == "SignalR"
    error_message = "The default resource kind must be SignalR."
  }

  assert {
    condition     = azapi_resource.this.body.sku.name == "Standard_S1" && azapi_resource.this.body.sku.tier == "Standard" && azapi_resource.this.body.sku.capacity == 1
    error_message = "The default SKU must be Standard_S1 with Standard tier and capacity 1."
  }

  assert {
    condition     = contains(azapi_resource.this.body.properties.cors.allowedOrigins, "*")
    error_message = "The default CORS configuration must allow all origins."
  }

  assert {
    condition     = azapi_resource.this.body.properties.disableAadAuth == false && azapi_resource.this.body.properties.disableLocalAuth == true
    error_message = "The default authentication settings must enable Microsoft Entra ID and disable local authentication."
  }

  assert {
    condition     = azapi_resource.this.body.properties.features[0].flag == "ServiceMode" && azapi_resource.this.body.properties.features[0].value == "Serverless"
    error_message = "The default ServiceMode feature must use Serverless mode."
  }

  assert {
    condition     = azapi_resource.this.tags == var.tags
    error_message = "The SignalR tags must match the module input."
  }

  assert {
    condition     = output.name == var.name
    error_message = "The name output must match the SignalR service name."
  }

  assert {
    condition     = output.resource_id == azapi_resource.this.id
    error_message = "The resource ID output must match the SignalR resource ID."
  }

  assert {
    condition     = output.location == var.location
    error_message = "The location output must match the SignalR location."
  }
}

run "supports_azapi_controls" {
  command = apply

  variables {
    resource_types = {
      signalrservice_signal_r = "Microsoft.SignalRService/signalR@2024-03-01"
    }
    retry = {
      error_message_regex  = ["RetryableError"]
      interval_seconds     = 10
      max_interval_seconds = 30
    }
    timeouts = {
      create = "45m"
      read   = "5m"
      update = "45m"
      delete = "30m"
    }
    ignore_body_changes = {
      signalrservice_signal_r = ["properties.features"]
    }
  }

  assert {
    condition     = azapi_resource.this.retry.interval_seconds == 10
    error_message = "The retry configuration must be passed to the SignalR resource."
  }

  assert {
    condition     = azapi_resource.this.timeouts.create == "45m"
    error_message = "The timeout configuration must be passed to the SignalR resource."
  }
}

run "rejects_invalid_name" {
  command = plan

  variables {
    name = "1-invalid-name"
  }

  expect_failures = [var.name]
}

run "rejects_invalid_parent_id" {
  command = plan

  variables {
    parent_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  }

  expect_failures = [var.parent_id]
}

run "rejects_invalid_kind" {
  command = plan

  variables {
    kind = "WebPubSub"
  }

  expect_failures = [var.kind]
}
