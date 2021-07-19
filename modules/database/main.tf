resource "azurerm_mysql_server" "primary" {
    name = var.primary_database
    resource_group_name = var.resource_group
    location = var.location
    version = var.primary_database_version
    administrator_login = var.primary_database_admin
    administrator_login_password = var.primary_database_password

    sku_name   = "B_Gen5_2"
    storage_mb = 5120
    #version    = "5.7"

    auto_grow_enabled                 = true
    backup_retention_days             = 7
    geo_redundant_backup_enabled      = false
    infrastructure_encryption_enabled = false
    public_network_access_enabled     = true
    ssl_enforcement_enabled           = true
    ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "db" {
  name                = "db"
  resource_group_name = var.resource_group
  server_name         = azurerm_mysql_server.primary.name

  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

