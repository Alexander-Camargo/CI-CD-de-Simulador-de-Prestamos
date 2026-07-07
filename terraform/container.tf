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
