# Azure SignalR Service

This module deploys an Azure SignalR Service instance using the AzAPI provider.

The caller supplies the fully-qualified resource ID of an existing resource group through `parent_id`. By default, the module deploys a `Standard_S1` SignalR service in Serverless mode, enables Microsoft Entra ID authentication, disables access-key authentication, and allows all CORS origins. Each default can be overridden through the module inputs.
