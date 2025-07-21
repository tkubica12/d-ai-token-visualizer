# Output values
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azapi_resource.resource_group.name
}

output "container_app_environment_name" {
  description = "Name of the Container App Environment"
  value       = azapi_resource.container_app_environment.name
}

output "llm_service_name" {
  description = "Name of the LLM service container app"
  value       = azapi_resource.llm_service.name
}

output "token_visualizer_name" {
  description = "Name of the Token Visualizer container app"
  value       = azapi_resource.token_visualizer.name
}

output "token_visualizer_url" {
  description = "URL of the Token Visualizer application"
  value       = "https://${azapi_resource.token_visualizer.output.properties.configuration.ingress.fqdn}"
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azapi_resource.log_analytics.id
}
