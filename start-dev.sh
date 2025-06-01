#!/bin/bash

echo "🚀 TODOアプリケーションを開発モードで起動しています..."

# Docker Composeでアプリケーションを起動
docker-compose up --build

echo "✅ アプリケーションが起動しました！"
echo "📱 ブラウザで http://localhost:8080 にアクセスしてください"
echo "🗄️  MySQL: localhost:3306 (ユーザー: todouser, パスワード: todopassword)"
echo "🛑 停止するには Ctrl+C を押してください"
