# Terraform Azure デプロイメント

このディレクトリには、TODOアプリをAzureにデプロイするためのTerraformファイルが含まれています。

## 構成

- **Azure Container Apps**: アプリケーションのホスティング
- **Azure Database for MySQL**: データベース
- **Azure Container Registry**: Dockerイメージの保存
- **Log Analytics Workspace**: ログとモニタリング

## 前提条件

1. **Azure CLI** がインストールされていること
2. **Terraform** がインストールされていること
3. **Docker** がインストールされていること
4. Azureサブスクリプションがあること

## デプロイ手順

### 1. Azure CLIログイン

```bash
az login
az account set --subscription "your-subscription-id"
```

### 2. 変数ファイルの設定

```bash
cd infrastructure
cp terraform.tfvars.example terraform.tfvars
```

`terraform.tfvars`を編集して、適切な値を設定してください：

```hcl
mysql_admin_password = "YourSecurePassword123!"
# その他の設定も必要に応じて変更
```

### 3. Terraformの初期化

```bash
terraform init
```

### 4. プランの確認

```bash
terraform plan
```

### 5. デプロイの実行

```bash
terraform apply
```

### 6. Dockerイメージのビルドとプッシュ

デプロイ完了後、出力される指示に従ってDockerイメージをプッシュしてください：

```bash
# ACRにログイン
az acr login --name <acr-name>

# イメージをビルド
docker build -f java/Dockerfile --target production -t <acr-server>/todo-app:latest ./java

# イメージをプッシュ
docker push <acr-server>/todo-app:latest

# Container Appを更新
az containerapp update --name <app-name> --resource-group <rg-name>
```

### 7. データベースの初期化

```bash
mysql -h <mysql-fqdn> -u <username> -p <database-name> < ../mysql/init/01-create-tables.sql
```

## tf.stateファイルの管理

### ローカル管理（一人開発）

デフォルトではローカルにtf.stateファイルが保存されます。

### Azure Storage Account管理（推奨）

チーム開発や本番環境では、Azure Storage Accountでの管理を推奨します：

#### 1. Storage Accountの作成

```bash
# リソースグループ作成
az group create --name terraform-state-rg --location "Japan East"

# Storage Account作成
az storage account create \
  --name terraformstate$(date +%s) \
  --resource-group terraform-state-rg \
  --location "Japan East" \
  --sku Standard_LRS

# コンテナ作成
az storage container create \
  --name tfstate \
  --account-name <storage-account-name>
```

#### 2. versions.tfの更新

`versions.tf`のbackend設定のコメントアウトを外して、適切な値を設定してください：

```hcl
backend "azurerm" {
  resource_group_name  = "terraform-state-rg"
  storage_account_name = "terraformstate[ランダム文字列]"
  container_name       = "tfstate"
  key                  = "todo-app.terraform.tfstate"
}
```

#### 3. 既存のstateファイルの移行

```bash
terraform init -migrate-state
```

## 環境別デプロイ

### 開発環境

```bash
terraform workspace new dev
terraform apply -var="environment=dev"
```

### 本番環境

```bash
terraform workspace new prod
terraform apply -var="environment=prod" -var="mysql_sku_name=B_Standard_B2s"
```

## リソースの削除

```bash
terraform destroy
```

## トラブルシューティング

### よくある問題

1. **ACR認証エラー**
   ```bash
   az acr login --name <acr-name>
   ```

2. **Container App起動失敗**
   ```bash
   az containerapp logs show --name <app-name> --resource-group <rg-name>
   ```

3. **MySQL接続エラー**
   - ファイアウォール規則を確認
   - 接続文字列を確認

### ログ確認

```bash
# Container Appのログ
az containerapp logs show --name <app-name> --resource-group <rg-name> --follow

# MySQL接続テスト
mysql -h <mysql-fqdn> -u <username> -p
```

## セキュリティ考慮事項

1. **パスワード管理**: Azure Key Vaultの使用を検討
2. **ネットワーク**: プライベートエンドポイントの設定
3. **アクセス制御**: RBACの適切な設定
4. **監査**: Azure Security Centerの有効化

## コスト最適化

1. **開発環境**: 小さなSKUを使用
2. **自動停止**: 開発環境では夜間停止を検討
3. **リザーブドインスタンス**: 本番環境では長期契約を検討
