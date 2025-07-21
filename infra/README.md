# Azure Container Apps Deployment

This Terraform configuration deploys the AI Token Visualizer application to Azure Container Apps with GPU support for the LLM service.

## Resources Created

- **Resource Group**: Contains all resources with unique naming (4 random characters)
- **Log Analytics Workspace**: For monitoring and logging
- **Container App Environment**: Shared environment with GPU workload profile support
- **LLM Service**: Internal container app using GPU workload profile (NC8as-T4)
- **Token Visualizer**: Public web application with auto-scaling

## Prerequisites

- Azure CLI installed and authenticated
- Terraform >= 1.0 installed
- HuggingFace token for model access

## Deployment

1. Navigate to the `infra` directory
2. Set your HuggingFace token:
   ```bash
   # Create demo.auto.tfvars or terraform.tfvars
   echo 'huggingface_token = "your-hf-token-here"' > demo.auto.tfvars
   ```
3. Deploy:
   ```bash
   terraform init
   terraform apply
   ```

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `huggingface_token` | HuggingFace token for model access | Required |
| `location` | Azure region | `swedencentral` |
| `environment` | Environment name | `dev` |

## Outputs

After deployment, you'll get:
- **token_visualizer_url**: URL to access the web application
- Resource names and IDs

## GPU Support

The LLM service runs on **NC8as-T4** GPU workload profile for optimal AI model performance. Both services auto-scale to 0 when not in use for cost optimization.
