# 1. Cuenta de Cosmos DB (Base de Datos NoSQL)
resource "azurerm_cosmosdb_account" "db" {
  name                = "${var.prefix}-cosmos-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "MongoDB"

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
    name   = "backend"
    image  = "${var.acr_login_server}/backend:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    # INYECCIÓN SEGURA DE CREDENCIALES (Tu punto fuerte en la evaluación)
    secure_environment_variables = {
      "DATABASE_URL" = azurerm_cosmosdb_account.db.connection_strings[0]
    }
  }

  container {
    name   = "frontend"
    image  = "${var.acr_login_server}/frontend:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}