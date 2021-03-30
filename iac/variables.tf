variable "vmsize" {
  type                      = string
  description               = "Size of VM to create"
}

variable "prefix" {
  type                      = string
  description               = "A prefix used for all resources"
}

variable "location" {
  type                      = string
  default                   = "eastus"
  description               = "The Azure Region used"
}
