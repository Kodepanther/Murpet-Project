# infra/main.tf

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
}

# 1. Log Analytics Workspace (The Database for Logs)
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.project_name}-logs-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# 2. Application Insights (The Monitor)
resource "azurerm_application_insights" "appinsights" {
  name                = "${var.project_name}-insights-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.logs.id
  application_type    = "Node.JS"
}

# 3. App Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "${var.project_name}-${var.environment}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "S1"
}

# 4. Web App
resource "azurerm_linux_web_app" "app" {
  name                = "${var.project_name}-web-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = true
    application_stack {
      node_version = "18-lts"
    }
  }

  # Link the App to App Insights
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.appinsights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }
}

# 5. Deployment Slot (Prod only)
resource "azurerm_linux_web_app_slot" "deployment_slot" {
  count          = var.environment == "prod" ? 1 : 0
  name           = "staging-slot"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }

  # Link the Slot to App Insights too
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.appinsights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }
}