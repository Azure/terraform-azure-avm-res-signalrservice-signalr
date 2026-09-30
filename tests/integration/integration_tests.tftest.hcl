run "setup" {
  command = apply

  module {
    source = "./tests/integration/setup"
  }
}

run "creates_signalr" {
  command = apply

  variables {
    location  = run.setup.location
    name      = "sigr-avm-${substr(md5(run.setup.resource_group_name), 0, 8)}"
    parent_id = run.setup.resource_group_id
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
