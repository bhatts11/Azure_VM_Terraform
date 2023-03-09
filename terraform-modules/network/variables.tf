variable "location" {
  type        = string
  default     = "eastus2"
  description = "location for vent & subnet deployments"
  validation {
    condition     = contains(["eastus2", "centralus"], lower(var.location))
    error_message = "Unsupported Azure Region specified for network. Only East US2 and Central US Azure Regions are supported."
  }
}
variable "rg_Name" {
  type        = string
  default     = ""
  description = "Resource group name to deploy the resources"
}
variable "vnet_Name" {
  type        = string
  default     = ""
  description = "Name of the vnet to create "
  validation {
    condition     = length(var.vnet_Name) > 6 && can(regex("dev", lower(var.vnet_Name)))
    error_message = " The vnet_Name must be valied name, should contain \" dev \". This can be configured in variables.tf file to streamline according to the environment."
  }
}
variable "vnet_Address" {
  type        = string
  default     = ""
  description = "The address space that is used by the virtual network"
}
variable "subnet_NameList" {
  type        = list(string)
  default     = [""]
  description = "List of subnet names inside the Vnet"
  validation {
    condition = alltrue([
      for snet in var.subnet_NameList : length(snet) > 6 && can(regex("dev", lower(snet))) || can(regex("gate", lower(snet)))
    ])
    error_message = " The subnet_NameList must be valied name, should contain \" dev \". This can be configured in variables.tf file to streamline according to the environment."
  }
}
variable "subnet_AddressList" {
  type        = list(string)
  default     = [""]
  description = "The address prefix to use for the subnet."
}
