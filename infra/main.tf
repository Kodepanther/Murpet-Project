# infra/main.tf

# 1. Create the Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
}

# 2. Create the App Service Plan (The Server Farm)
resource "azurerm_service_plan" "plan" {
  name                = "${var.project_name}-${var.environment}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "S1" # Standard S1 is required for Slots
}

# 3. Create the Web Application
resource "azurerm_linux_web_app" "app" {
  name                = "${var.project_name}-web-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = true # Recommended for Production apps
    
    application_stack {
      node_version = "18-lts" # Change this to python or dotnet if needed
    }
  }
}

# 4. Create the Deployment Slot (ONLY for Production)
# This logic checks if var.environment is 'prod'. If yes, it creates 1 slot. If no, 0.
resource "azurerm_linux_web_app_slot" "deployment_slot" {
  count          = var.environment == "prod" ? 1 : 0
  
  name           = "staging-slot"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}