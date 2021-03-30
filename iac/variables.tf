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
