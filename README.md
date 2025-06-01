# Spring Boot TODO アプリケーション

JavaのSpring Bootフレームワークを使用したシンプルなTODOアプリケーションです。フロントエンドにはThymeleafテンプレートエンジンを使用し、データベースにはMySQLを使用しています。

## 機能

- ✅ TODOの作成、編集、削除
- ✅ TODOの完了/未完了の切り替え
- ✅ TODOのフィルタリング（すべて/未完了/完了済み）
- ✅ タイトルによる検索機能
- ✅ レスポンシブデザイン（Bootstrap使用）
- ✅ ホットリロード対応（開発環境）
- ✅ マルチステージビルド（Docker）

## 技術スタック

### バックエンド
- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Data JPA**
- **Hibernate**
- **Maven**

### フロントエンド
- **Thymeleaf**
- **Bootstrap 5.1.3**
- **Font Awesome 6.0.0**

### データベース
- **MySQL 8.0**

### インフラ
- **Docker & Docker Compose**
- **マルチステージビルド**

## プロジェクト構成

```
java-azure/
├── compose.yml                 # Docker Compose設定
├── mysql/
│   └── init/
│       └── 01-create-tables.sql # データベース初期化スクリプト
├── java/
│   ├── Dockerfile              # Javaアプリケーション用Dockerfile
│   ├── pom.xml                 # Maven設定
│   └── src/
│       ├── main/
│       │   ├── java/com/example/todoapp/
│       │   │   ├── TodoAppApplication.java      # メインアプリケーション
│       │   │   ├── controller/
│       │   │   │   └── TodoController.java      # Webコントローラー
│       │   │   ├── entity/
│       │   │   │   └── Todo.java                # TODOエンティティ
│       │   │   ├── repository/
│       │   │   │   └── TodoRepository.java      # データアクセス層
│       │   │   └── service/
│       │   │       └── TodoService.java         # ビジネスロジック層
│       │   ├── resources/
│       │   │   ├── application.properties       # アプリケーション設定
│       │   │   └── templates/                   # Thymeleafテンプレート
│       │   │       ├── index.html               # メインページ
│       │   │       └── edit.html                # 編集ページ
│       │   └── webapp/
└── start-dev.sh               # 開発環境起動スクリプト
```

## セットアップと実行

### 前提条件
- Docker
- Docker Compose

### 1. リポジトリのクローン
```bash
git clone <repository-url>
cd java-azure
```

### 2. アプリケーションの起動
```bash
# 開発環境での起動（ホットリロード有効）
docker compose up --build

# または、起動スクリプトを使用
chmod +x start-dev.sh
./start-dev.sh
```

### 3. アプリケーションへのアクセス
ブラウザで以下のURLにアクセスしてください：
- **アプリケーション**: http://localhost:8080
- **MySQL**: localhost:3306
  - ユーザー: `todouser`
  - パスワード: `todopassword`
  - データベース: `todoapp`

## 使用方法

### TODOの作成
1. メインページの「新しいTODOを追加」セクションでタイトルと説明を入力
2. 「追加」ボタンをクリック

### TODOの管理
- **完了/未完了の切り替え**: 各TODOカードの「完了」または「未完了に戻す」ボタンをクリック
- **編集**: 「編集」ボタンをクリックして編集ページに移動
- **削除**: 「削除」ボタンをクリック（確認ダイアログが表示されます）

### フィルタリングと検索
- **フィルター**: 「すべて」「未完了」「完了済み」ボタンでTODOをフィルタリング
- **検索**: 検索ボックスにタイトルの一部を入力して検索

## 開発

### ホットリロード
開発環境では、Spring Boot DevToolsが有効になっており、ソースコードの変更が自動的に反映されます。

### データベースの初期化
初回起動時に、`mysql/init/01-create-tables.sql`スクリプトが実行され、必要なテーブルとサンプルデータが作成されます。

### 本番環境用ビルド
```bash
# 本番環境用のイメージをビルド
docker build --target production -t todo-app:prod ./java

# 本番環境での実行
docker run -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://your-mysql-host:3306/todoapp \
  -e SPRING_DATASOURCE_USERNAME=your-username \
  -e SPRING_DATASOURCE_PASSWORD=your-password \
  todo-app:prod
```

## API エンドポイント

| メソッド | エンドポイント | 説明 |
|---------|---------------|------|
| GET | `/` | メインページ表示 |
| GET | `/?filter={status}` | フィルタリング（incomplete/completed） |
| GET | `/?search={query}` | タイトル検索 |
| POST | `/create` | 新しいTODO作成 |
| GET | `/edit/{id}` | TODO編集ページ表示 |
| POST | `/update/{id}` | TODO更新 |
| POST | `/toggle/{id}` | TODO完了状態切り替え |
| POST | `/delete/{id}` | TODO削除 |

## トラブルシューティング

### アプリケーションが起動しない場合
1. Dockerが正常に動作していることを確認
2. ポート8080と3306が使用されていないことを確認
3. `docker compose down`でコンテナを停止してから再起動

### データベース接続エラー
1. MySQLコンテナが正常に起動していることを確認
2. `docker compose logs mysql`でMySQLのログを確認

### ホットリロードが動作しない場合
1. ファイルの変更が保存されていることを確認
2. `docker compose logs java-app`でアプリケーションログを確認

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。
