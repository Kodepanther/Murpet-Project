# infra/variables.tf

variable "location" {
  description = "The Azure Region to deploy resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "The environment name (dev, staging, or prod)"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "murpet"
}