locals {
  # Generate 4 random characters for unique naming
  random_suffix = random_string.suffix.result
  
  # Common naming convention
  base_name = "visualizer-${local.random_suffix}"
  
  # Get subscription ID for parent_id references
  subscription_id = data.azapi_client_config.current.subscription_id
}

# Get current Azure configuration
data "azapi_client_config" "current" {}

# Generate random suffix for unique naming
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Resource Group
resource "azapi_resource" "resource_group" {
  type      = "Microsoft.Resources/resourceGroups@2024-07-01"
  name      = local.base_name
  location  = var.location
  parent_id = "/subscriptions/${local.subscription_id}"

  body = {
    properties = {}
  }
}

# Log Analytics Workspace
resource "azapi_resource" "log_analytics" {
  type      = "Microsoft.OperationalInsights/workspaces@2023-09-01"
  name      = "${local.base_name}-logs"
  location  = var.location
  parent_id = azapi_resource.resource_group.id

  body = {
    properties = {
      retentionInDays = 30
      sku = {
        name = "PerGB2018"
      }
      publicNetworkAccessForIngestion = "Enabled"
      publicNetworkAccessForQuery     = "Enabled"
      features = {
        enableLogAccessUsingOnlyResourcePermissions = true
      }
    }
  }

  response_export_values = ["*"]
}

# Get Log Analytics shared keys
resource "azapi_resource_action" "log_analytics_keys" {
  type                   = "Microsoft.OperationalInsights/workspaces@2023-09-01"
  resource_id            = azapi_resource.log_analytics.id
  action                 = "sharedKeys"
  method                 = "POST"
  response_export_values = ["*"]
}