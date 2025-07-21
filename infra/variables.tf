# Global variables
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "swedencentral"
}

variable "huggingface_token" {
  description = "HuggingFace token for model access"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}
