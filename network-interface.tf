locals {
  subnet = (
    length(coalesce(var.ip_config, {})) != 0 ?
      data.azurerm_subnet.subnet[var.ip_config.subnet].id : null
  )

  private_ip_address = (
    length(coalesce(var.ip_config, {})) != 0 ?
      var.ip_config.ip_address : null
  )
}

resource azurerm_network_interface network_interface {
  name = format("%s-%s-%03d",
    substr(
      module.naming.network_interface.name, 0,
      module.naming.network_interface.max_length - 6
    ),
    substr(local.environment, 0, 3),
    var.info.sequence
  )

  resource_group_name = var.resource_group
  location            = var.region

  dns_servers             = var.dns_servers
  internal_dns_name_label = var.internal_dns_name

  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "internal"
    primary                       = true
    subnet_id                     = local.subnet
    private_ip_address_allocation = var.ip_address_type
    private_ip_address            = local.private_ip_address
  }

  tags = local.tags
}
