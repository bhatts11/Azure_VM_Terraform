## Subscription ID, Resource Group and Location set. These are kept universal in this code. ####
variable "subscription_id" {
  type    = string
  default = ""
}
variable "location" {
  type    = string
  default = ""
}
variable "rg_Name" {
  type    = string
  default = ""
}

### VNET Module Variables Start ###

variable "vnet_Name" {
  type    = string
  default = ""
}
variable "vnet_Address" {
  type    = string
  default = ""
}
variable "subnet_NameList" {
  type    = list(string)
  default = [""]
}
variable "subnet_AddressList" {
  type    = list(string)
  default = [""]
}

## Pre defined KV details
variable "devKV_Name" {
  type    = string
  default = ""
}
#### Variables for Linux Virtual Module defined here ####

variable "vm_pip" {
  type        = string
  default     = ""
  description = "Name of the Public IP instance assigned to the Virtual Machine"
}
variable "pip_allocation" {
  type    = string
  default = ""
  validation {
    condition     = contains(["static", "dynamic"], lower(var.pip_allocation))
    error_message = "Public IP assignment can be either Static or Dynamic. Please correct your selection."
  }
  description = "Public IP assignment type"
}
variable "vm_nic" {
  type        = string
  default     = ""
  description = "Network Interface card name assigned to the Virtual Machine"
}

variable "ip_configuration" {
  type        = string
  default     = ""
  description = "IP configuration name for the Virtual Machine."
}
variable "vm_name" {
  type        = string
  default     = ""
  description = "Name of the Virtual Machine to be created."
}
variable "vm_size" {
  type        = string
  default     = ""
  description = "Virtual Machine \"Size\"SKU\" to be created such as : Standard_F2"
}
variable "vm_username" {
  type        = string
  default     = ""
  description = "Username for Azure Virtual Machine"
}
variable "vm_password" {
  type        = string
  default     = ""
  description = "Password for Azure Virtual Machine"
}

variable "vm_image_publisher" {
  type        = string
  default     = ""
  description = "Azure Virtual Machine Publisher such as : MicrosoftWindowsServer."
}
variable "vm_image_offer" {
  type        = string
  default     = ""
  description = "Image Offer for the Publisher selected. Available options can be : WindowsServer."
}
variable "vm_image_sku" {
  type        = string
  default     = ""
  description = "Image Version or SKU for the publisher you have chosen. Such as 2019-Datacenter, 2016-Datacenter, etc."
}
variable "vm_image_version" {
  type        = string
  default     = ""
  description = "This is the Image Version of the SKU that you have selected. Usually the selected option is \"Latest\". "
}
variable "vm_os_disk_strg_type" {
  type        = string
  default     = "Standard_LRS"
  description = "OS Disk Storage Type. Possible options are Standard_LRS, StandardSSD_LRS and Premium_LRS."
}

variable "vm_os_disk_caching" {
  type        = string
  default     = "ReadWrite"
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite."

}

variable "virtual_machine_Usr" {
  type        = string
  description = "Username for Azure Virtual Machine. This will be fetched from Key Vault."
}

variable "virtual_machine_Passwd" {
  type        = string
  description = "Password for Azure Virtual Machine. This will be fetched from Key Vault."
}

# variable "vm_subnetid" {
#   type        = string
#   description = "Subnet Id for the Virtual machine. This will be fetched from Network Module."
# }