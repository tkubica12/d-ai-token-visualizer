# LLM Service Container App
resource "azapi_resource" "llm_service" {
  type      = "Microsoft.App/containerApps@2024-10-02-preview"
  name      = "${local.base_name}-llm"
  location  = var.location
  parent_id = azapi_resource.resource_group.id

  body = {
    properties = {
      environmentId = azapi_resource.container_app_environment.id
      configuration = {
        activeRevisionsMode = "Single"
        ingress = {
          external               = false
          targetPort            = 8001
          transport             = "Http"
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
          name      = "llm-service"
          image     = "ghcr.io/tkubica12/d-ai-token-visualizer/llm_service:gpu"
          imageType = "ContainerImage"
          resources = {
            cpu    = 8
            memory = "56Gi"
          }
          env = [
            {
              name  = "QUANTIZATION"
              value = "Q8"
            },
            {
              name  = "HUGGINGFACE_TOKEN"
              value = var.huggingface_token
            }
          ]
        }]
        scale = {
          minReplicas     = 0
          maxReplicas     = 1
          cooldownPeriod  = 3600
          pollingInterval = 30
        }
      }
      workloadProfileName = "NC8as-T4"
    }
  }

  identity {
    type = "None"
  }
}