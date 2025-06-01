# ランダム文字列生成（リソース名のユニーク性確保）
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# リソースグループ
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Azure Container Registry
resource "azurerm_container_registry" "main" {
  name                = "${var.app_name}acr${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = var.tags
}

# Azure Database for MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "main" {
  name                   = "${var.app_name}-mysql-${random_string.suffix.result}"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  backup_retention_days  = 7
  sku_name               = var.mysql_sku_name
  version                = "8.0.21"
  
  storage {
    size_gb = var.mysql_storage_size_gb
  }

  tags = var.tags
}

# MySQL データベース
resource "azurerm_mysql_flexible_database" "main" {
  name                = var.mysql_database_name
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# MySQL ファイアウォール規則（Azure サービスからのアクセスを許可）
resource "azurerm_mysql_flexible_server_firewall_rule" "azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Log Analytics Workspace（Container Apps用）
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.app_name}-logs-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                       = "${var.app_name}-env-${random_string.suffix.result}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = var.tags
}

# Container App
resource "azurerm_container_app" "main" {
  name                         = var.app_name
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = var.tags

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "todo-app"
      image  = "${azurerm_container_registry.main.login_server}/todo-app:${var.docker_image_tag}"
      cpu    = var.container_cpu
      memory = var.container_memory

      env {
        name  = "SPRING_DATASOURCE_URL"
        value = "jdbc:mysql://${azurerm_mysql_flexible_server.main.fqdn}:3306/${var.mysql_database_name}?useSSL=true&requireSSL=false&serverTimezone=UTC"
      }

      env {
        name  = "SPRING_DATASOURCE_USERNAME"
        value = var.mysql_admin_username
      }

      env {
        name        = "SPRING_DATASOURCE_PASSWORD"
        secret_name = "mysql-password"
      }

      env {
        name  = "SPRING_JPA_HIBERNATE_DDL_AUTO"
        value = "update"
      }

      env {
        name  = "SPRING_JPA_SHOW_SQL"
        value = "false"
      }

      env {
        name  = "SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT"
        value = "org.hibernate.dialect.MySQLDialect"
      }
    }
  }

  secret {
    name  = "mysql-password"
    value = var.mysql_admin_password
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    username = azurerm_container_registry.main.admin_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = azurerm_container_registry.main.admin_password
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  depends_on = [
    azurerm_mysql_flexible_server_firewall_rule.azure_services
  ]
}
