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

terraform {
  required_version = "~> 0.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.33.0"
    }
  }
}

locals {
  project     = lower(var.info.project)
  environment = lower(var.info.environment)

  tags = merge(
    {
      for key, value in var.tags : lower(key) => lower(value)
    },
    {
      project     = local.project
      environment = local.environment
    }
  )

  ip_config = (
    length(coalesce(var.ip_config, {})) == 0 ?
      [] : [var.ip_config]
  )
}

data azurerm_subnet subnet {
  for_each = {
    for config in local.ip_config : config.subnet => config
  }

  name                 = each.value.subnet
  virtual_network_name = each.value.virtual_network
  resource_group_name  = each.value.resource_group
}

module naming {
  source  = "Azure/naming/azurerm"
  version = "0.1.0"

  suffix = [local.project]
}
