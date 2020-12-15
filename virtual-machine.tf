locals {
  admin_user     = "VMAdmin"
  admin_password = random_password.admin_password.result

  encryption_enabled = (
    length(coalesce(var.os_disk.encryption_enabled, {})) != 0 ?
      var.os_disk.encryption_enabled : false
  )

  encryption_set = (
    local.encryption_enabled ?
      azurerm_disk_encryption_set.disk_encryption_set.id : null
  )

  key_vault = (
    local.encryption_enabled ?
      []
  )
}

resource random_password admin_password {
  length           = 24
  special          = true
  override_special = "_%@!$"
}

resource azurerm_disk_encryption_set disk_encryption_set {
  for_each = {
    
  }
}

resource azurerm_windows_virtual_machine windows_virtual_machine {
  name = format("%s-%s-%03d",
    substr(
      module.naming.windows_virtual_machine.name, 0,
      module.naming.windows_virtual_machine.max_length - 6
    ),
    substr(local.environment, 0, 3),
    var.info.sequence
  )

  resource_group_name  = var.resource_group
  location             = var.region
  size                 = var.virtual_machine_size

  network_interface_ids = [azurerm_network_interface.network_interface.id]

  admin_username = local.admin_user
  admin_password = local.admin_password

  os_disk {
    caching                = var.os_disk.caching_type
    storage_account_type   = var.os_disk.storage_type
    disk_encryption_set_id = local.encryption_set
  }
}
