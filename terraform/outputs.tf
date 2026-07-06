output "aci_private_ip" {
  value       = azurerm_container_group.aci.ip_address
  description = "IP Privada de la aplicación desplegada en ACI"
}