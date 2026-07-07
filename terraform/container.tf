# 1. Cuenta de Cosmos DB (Base de Datos NoSQL)
resource "azurerm_cosmosdb_account" "db" {
  name                = "${var.prefix}-cosmos-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

# 2. Azure Container Instance (Donde correrá tu aplicación)
resource "azurerm_container_group" "aci" {
  name                = "${var.prefix}-aci-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Private"
  os_type             = "Linux"
  subnet_ids          = [var.subnet_id]

  container {
    name   = "simulador-app"
    image  = "${var.acr_login_server}/simulador-app:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 8080
      protocol = "TCP"
    }

    # INYECCIÓN SEGURA DE CREDENCIALES
    secure_environment_variables = {
      "COSMOS_CONNECTION_STRING" = azurerm_cosmosdb_account.db.connection_strings[0]
      "PORT"                     = "8080"
    }
  }
}


