variable "enable-bastion" {
  type                    = bool
  default                 = false
  description             = "Decide if this will have a bastion or not"
}

variable "vmsize" {
  type                      = string
  description               = "Size of VM to create"
}

variable "vmImage" {
  type                      = string
  description               = "VM image to use for work vm"
}

variable "prefix" {
  type                      = string
  description               = "A prefix used for all resources"
}

variable "location" {
  type                      = string
  description               = "The Azure Region used"
}

variable "datadisk_size_gb" {
  type                      = number 
  description               = "Size of data disk in GB"
}

variable "project-rg" {
  type                      = string
  description               = "Resource Group project resources will be created in"
}

variable "agent-vnet-name" {
  type                      = string
  description               = "VNet of agent network to peer to"
}

variable "agent-vnet-rg" {
  type                      = string
  description               = "Resource Group that contains Agent VNet to Peer to"
}
