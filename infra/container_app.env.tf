# Container App Environment
resource "azapi_resource" "container_app_environment" {
  type      = "Microsoft.App/managedEnvironments@2024-10-02-preview"
  name      = "${local.base_name}-env"
  location  = var.location
  parent_id = azapi_resource.resource_group.id

  body = {
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azapi_resource.log_analytics.output.properties.customerId
          sharedKey  = azapi_resource_action.log_analytics_keys.output.primarySharedKey
        }
      }
      workloadProfiles = [
        {
          name                = "Consumption"
          workloadProfileType = "Consumption"
        },
        {
          name                = "NC8as-T4"
          workloadProfileType = "Consumption-GPU-NC8as-T4"
        }
      ]
      zoneRedundant = false
      peerAuthentication = {
        mtls = {
          enabled = false
        }
      }
    }
  }
}