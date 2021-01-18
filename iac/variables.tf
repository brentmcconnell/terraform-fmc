variable "prefix" {
  type                      = string
  default                   = "tf"
  description               = "A prefix used for all resources"
}

variable "location" {
  type                      = string
  default                   = "eastus"
  description               = "The Azure Region used"
}

variable "clientId" {
  type                      = string
  description               = "SP client id"
}

# variable "clientCert" {
#   type                      = string
#   description               = "SP client secret"
# }

variable "subscriptionId" {
  type                      = string
  description               = "SP subscription id"
}

variable "tenantId" {
  type                      = string
  description               = "SP tenant id"
}
