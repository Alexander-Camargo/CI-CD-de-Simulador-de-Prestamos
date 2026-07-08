# Cuenta de Cosmos DB (Base de Datos NoSQL)

resource "azurerm_cosmosdb_account" "db" {

  name                = "${var.prefix}-cosmos-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  offer_type = "Standard"
  kind       = "GlobalDocumentDB"


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


  os_type = "Linux"

  ip_address_type = "Public"
  dns_name_label  = "simulador-app-${var.prefix}-${var.environment}"

  depends_on = [

    azurerm_container_registry.acr,

  ]



  # Credenciales para acceder al Azure Container Registry

  image_registry_credential {

    server = azurerm_container_registry.acr.login_server

    username = azurerm_container_registry.acr.admin_username

    password = azurerm_container_registry.acr.admin_password

  }



  container {

    name = "simulador-app"


    image = "${azurerm_container_registry.acr.login_server}/simulador-app:latest"


    cpu = 0.5

    memory = 1.5



    ports {

      port = 8080

      protocol = "TCP"

    }



    secure_environment_variables = {

      PORT = "8080"

    }

  }

}
