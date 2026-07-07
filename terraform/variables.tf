variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "East US"
}

variable "prefix" {
  description = "Prefijo para los recursos"
  type        = string
  default     = "prestamos"
}

variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
  default     = "rg-prestamos"
}

variable "vnet_name" {
  description = "Nombre de la Virtual Network"
  type        = string
  default     = "vnet-prestamos"
}

variable "subnet_name" {
  description = "Nombre de la Subnet"
  type        = string
  default     = "subnet-prestamos"
}

variable "acr_name" {
  description = "Nombre del Azure Container Registry"
  type        = string
  default     = "acrprestamos2026"
}

variable "vnet_address_space" {
  description = "Espacio de direcciones de la VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Espacio de direcciones de la Subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# VARIABLE FALTANTE
variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
}
variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
}

variable "subnet_id" {
  description = "ID de la Subnet"
  type        = string
}

variable "acr_login_server" {
  description = "Login Server del Azure Container Registry"
  type        = string
}
