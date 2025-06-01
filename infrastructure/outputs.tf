output "resource_group_name" {
  description = "リソースグループ名"
  value       = azurerm_resource_group.main.name
}

output "container_registry_login_server" {
  description = "Container Registry ログインサーバー"
  value       = azurerm_container_registry.main.login_server
}

output "container_registry_admin_username" {
  description = "Container Registry 管理者ユーザー名"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "container_registry_admin_password" {
  description = "Container Registry 管理者パスワード"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}

output "mysql_server_fqdn" {
  description = "MySQL サーバーFQDN"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "mysql_server_name" {
  description = "MySQL サーバー名"
  value       = azurerm_mysql_flexible_server.main.name
}

output "mysql_database_name" {
  description = "MySQL データベース名"
  value       = azurerm_mysql_flexible_database.main.name
}

output "container_app_url" {
  description = "Container App URL"
  value       = "https://${azurerm_container_app.main.latest_revision_fqdn}"
}

output "container_app_fqdn" {
  description = "Container App FQDN"
  value       = azurerm_container_app.main.latest_revision_fqdn
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.main.id
}

output "container_app_environment_id" {
  description = "Container App Environment ID"
  value       = azurerm_container_app_environment.main.id
}

# デプロイ後の手順を表示
output "deployment_instructions" {
  description = "デプロイ後の手順"
  value = <<-EOT
    
    === デプロイ完了 ===
    
    1. Dockerイメージをビルドしてプッシュ:
       az acr login --name ${azurerm_container_registry.main.name}
       docker build -f java/Dockerfile --target production -t ${azurerm_container_registry.main.login_server}/todo-app:latest ./java
       docker push ${azurerm_container_registry.main.login_server}/todo-app:latest
    
    2. Container Appを更新:
       az containerapp update --name ${azurerm_container_app.main.name} --resource-group ${azurerm_resource_group.main.name}
    
    3. データベース初期化（必要に応じて）:
       mysql -h ${azurerm_mysql_flexible_server.main.fqdn} -u ${var.mysql_admin_username} -p ${var.mysql_database_name} < mysql/init/01-create-tables.sql
    
    4. アプリケーションURL:
       https://${azurerm_container_app.main.latest_revision_fqdn}
    
    5. ログ確認:
       az containerapp logs show --name ${azurerm_container_app.main.name} --resource-group ${azurerm_resource_group.main.name} --follow
    
    EOT
}
