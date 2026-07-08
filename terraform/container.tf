# Cuenta de Cosmos DB (Base de Datos NoSQL)
resource "azurerm_cosmosdb_account" "db" {
  name                = "${var.prefix}-cosmos-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  depends_on = [
    azurerm_resource_group.rg
  ]

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

# Azure Container Instance (Aplicación)
resource "azurerm_container_group" "aci" {
  name                = "${var.prefix}-aci-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type         = "Linux"
  ip_address_type = "Public"
  dns_name_label  = "simulador-app-${var.prefix}-${var.environment}"

  depends_on = [
    azurerm_container_registry.acr,
    azurerm_cosmosdb_account.db # Aseguramos que la DB exista antes que la app
  ]

  # Credenciales para acceder al Azure Container Registry
  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "simulador-app"
    image  = "${azurerm_container_registry.acr.login_server}/simulador-app:latest"
    cpu    = 0.5
    memory = 1.5

    # Regresamos el puerto al 8080 para que coincida perfectamente con tu Dockerfile
    ports {
      port     = 80
      protocol = "TCP"
    }

    secure_environment_variables = {
      PORT                     = "80" 
      COSMOS_CONNECTION_STRING = azurerm_cosmosdb_account.db.primary_sql_connection_string
      # Agregamos esta variable para obligar a Terraform a destruir y recrear el contenedor
      FORCE_RESTART            = "1"
    }
  }
}