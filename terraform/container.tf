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

  ip_address_type = "Private"
  os_type         = "Linux"

  subnet_ids = [
    azurerm_subnet.subnet.id
  ]

  container {
    name   = "simulador-app"
    image  = "${azurerm_container_registry.acr.login_server}/simulador-app:latest"

    cpu    = 0.5
    memory = 1.5

    ports {
      port     = 8080
      protocol = "TCP"
    }

    secure_environment_variables = {
      PORT = "8080"
    }
  }
}
