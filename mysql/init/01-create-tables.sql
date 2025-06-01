USE todoapp;

CREATE TABLE IF NOT EXISTS todos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- サンプルデータの挿入
INSERT INTO todos (title, description, completed) VALUES
('Spring Bootアプリの作成', 'TODOアプリのバックエンドを作成する', false),
('JSPフロントエンドの実装', 'ユーザーインターフェースを作成する', false),
('Docker設定の完了', 'マルチステージビルドとホットリロードの設定', false);
