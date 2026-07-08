resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-${var.prefix}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_port {
    name = "port-80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-pip-config"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  # Apuntamos a la IP privada del ACI generada dinámicamente
  backend_address_pool {
    name         = "aci-backend-pool"
    ip_addresses = [azurerm_container_group.aci.ip_address]
  }

  backend_http_settings {
    name                  = "http-setting-8080"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "listener-80"
    frontend_ip_configuration_name = "frontend-pip-config"
    frontend_port_name             = "port-80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "listener-80"
    backend_address_pool_name  = "aci-backend-pool"
    backend_http_settings_name = "http-setting-8080"
  }

  # Nos aseguramos de que el ACI exista antes de crear el AppGW
  depends_on = [
    azurerm_container_group.aci
  ]
}