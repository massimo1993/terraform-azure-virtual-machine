# Environment variables should be used for authentication.
#
# ARM_SUBSCRIPTION_ID
# ARM_CLIENT_ID
# ARM_CLIENT_SECRET
# ARM_TENANT_ID
#
# Reference the Azure Provider documentation for more information.
#
# https://www.terraform.io/docs/providers/azurerm/index.html

variable info {
  type = object({
    project     = string
    environment = string
    sequence    = string
  })

  description = "Info object used to construct naming convention for virtual machine."
}

variable tags {
  type        = map(string)
  description = "Tags object used to tag virtual machine."
}

variable resource_group {
  type        = string
  description = "Name of the resource group where the virtual machine will be deployed."
}

variable region {
  type        = string
  description = "Region where the virtual machine will be created."
}

variable ip_address_type {
  type        = string
  description = "The allocation method used for the IP address."

  default = "Dynamic"
}

variable ip_config {
  type = object({
    virtual_network = string
    subnet          = string
    resource_group  = string
    ip_address      = string
  })

  description = "Virtual machine IP address configuration."
  default     = null
}

variable dns_servers {
  type        = list(string)
  description = "A list of IP addresses defining the DNS servers which should be used."

  default = []
}

variable internal_dns_name {
  type        = string
  description = "The DNS name used for internal communications between virtual machines in the same VNET."

  default = null
}

variable enable_ip_forwarding {
  type        = bool
  description = "Determines if IP forwarding is enabled."

  default = false
}

variable enable_accelerated_networking {
  type        = bool
  description = "Determines if accelerated networking is enabled."

  default = false
}
