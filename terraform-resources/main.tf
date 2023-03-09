# backend storageaccount declaration to store the terraform state file. This should exist already.
terraform {
  backend "azurerm" {
    #   subscription_id       = "da74xxxx-9c9a-xxxx-8fae-xxxxxxxxxxxx"
    subscription_id      = "xxxxx"
    resource_group_name  = "Blog_RG"
    storage_account_name = "terraformbackend938" # Storage account used for backend
    container_name       = "blogstate"
    key                  = "terraform.tfstate" # Terraform State file
  }
}
# Azurerm providers declaration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.42.0"
    }
  }
  #required_version = ">= 0.13"
}
provider "azurerm" {
  alias                      = "coeauto"
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

### Data source for KV - to retrive the secrets from KV, declaring the existing KV details.
data "azurerm_key_vault" "kv_name" {
  name                = var.devKV_Name
  resource_group_name = "Blog_RG"
}
## To get object & tenant ID , declaring the data source. 
data "azurerm_client_config" "current" {}

#############################################################################

############# 1. VNET & SUBNET Deployment Code #############

module "vnet01" {
  source             = "../terraform-modules/network"
  vnet_Name          = var.vnet_Name
  rg_Name            = var.rg_Name
  location           = var.location
  vnet_Address       = var.vnet_Address
  subnet_NameList    = var.subnet_NameList
  subnet_AddressList = var.subnet_AddressList
}

######### 3. Azure Linux Virtual Machine deployment #########

data "azurerm_key_vault_secret" "virtual_machine_user" {
  name         = var.virtual_machine_Usr
  key_vault_id = data.azurerm_key_vault.kv_name.id
}

data "azurerm_key_vault_secret" "virtual_machine_passwd" {
  name         = var.virtual_machine_Passwd
  key_vault_id = data.azurerm_key_vault.kv_name.id
}

module "linux_vm" {
  depends_on           = [module.vnet01.subnet]
  source               = "../terraform-modules/virtual_machine"
  vm_pip               = var.vm_pip
  rg_Name              = var.rg_Name
  location             = var.location
  pip_allocation       = var.pip_allocation
  vm_nic               = var.vm_nic
  ip_configuration     = var.ip_configuration
  vm_name              = var.vm_name
  vm_size              = var.vm_size
  vm_username          = data.azurerm_key_vault_secret.virtual_machine_user.value
  vm_password          = data.azurerm_key_vault_secret.virtual_machine_passwd.value
  vm_image_publisher   = var.vm_image_publisher
  vm_image_offer       = var.vm_image_offer
  vm_image_sku         = var.vm_image_sku
  vm_image_version     = var.vm_image_version
  vm_os_disk_strg_type = var.vm_os_disk_strg_type
  vm_os_disk_caching   = var.vm_os_disk_caching
  vm_subnetid          = module.vnet01.subnet_Id[3]
}