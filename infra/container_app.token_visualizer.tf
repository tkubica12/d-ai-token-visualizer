# Token Visualizer Container App
resource "azapi_resource" "token_visualizer" {
  type      = "Microsoft.App/containerApps@2024-10-02-preview"
  name      = "${local.base_name}-app"
  location  = var.location
  parent_id = azapi_resource.resource_group.id

  body = {
    properties = {
      environmentId = azapi_resource.container_app_environment.id
      configuration = {
        activeRevisionsMode = "Single"
        ingress = {
          external               = true
          targetPort            = 80
          transport             = "Auto"
          allowInsecure         = false
          clientCertificateMode = "Ignore"
          traffic = [{
            latestRevision = true
            weight         = 100
          }]
        }
        maxInactiveRevisions = 100
      }
      template = {
        containers = [{
          name      = "token-visualizer"
          image     = "ghcr.io/tkubica12/d-ai-token-visualizer/token_visualizer:latest"
          imageType = "ContainerImage"
          resources = {
            cpu    = 0.75
            memory = "1.5Gi"
          }
          env = [{
            name  = "LLM_SERVICE_URL"
            value = "http://${local.base_name}-llm"
          }]
        }]
        scale = {
          minReplicas     = 0
          maxReplicas     = 1
          cooldownPeriod  = 3600
          pollingInterval = 30
        }
      }
      workloadProfileName = "Consumption"
    }
  }

  identity {
    type = "None"
  }
}