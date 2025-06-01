variable "resource_group_name" {
  description = "リソースグループ名"
  type        = string
  default     = "todo-app-rg"
}

variable "location" {
  description = "Azureリージョン"
  type        = string
  default     = "Japan East"
}

variable "app_name" {
  description = "アプリケーション名"
  type        = string
  default     = "todo-app"
}

variable "environment" {
  description = "環境名 (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "mysql_admin_username" {
  description = "MySQL管理者ユーザー名"
  type        = string
  default     = "tododbadmin"
}

variable "mysql_admin_password" {
  description = "MySQL管理者パスワード"
  type        = string
  sensitive   = true
}

variable "mysql_database_name" {
  description = "MySQLデータベース名"
  type        = string
  default     = "todoapp"
}

variable "mysql_sku_name" {
  description = "MySQL SKU名"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "mysql_storage_size_gb" {
  description = "MySQLストレージサイズ (GB)"
  type        = number
  default     = 20
}

variable "container_cpu" {
  description = "コンテナCPU"
  type        = number
  default     = 0.5
}

variable "container_memory" {
  description = "コンテナメモリ (Gi)"
  type        = string
  default     = "1Gi"
}

variable "min_replicas" {
  description = "最小レプリカ数"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "最大レプリカ数"
  type        = number
  default     = 3
}

variable "docker_image_tag" {
  description = "Dockerイメージタグ"
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default = {
    Project     = "TodoApp"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
