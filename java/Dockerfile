# マルチステージビルド - ビルドステージ
FROM maven:latest AS build

WORKDIR /app

# pom.xmlをコピーして依存関係をダウンロード（キャッシュ効率化）
COPY pom.xml .
RUN mvn dependency:go-offline -B

# ソースコードをコピーしてビルド
COPY src ./src
RUN mvn clean package -DskipTests

# 実行ステージ
FROM openjdk:17-jdk-slim AS runtime

WORKDIR /app

# ビルドステージからJARファイルをコピー
COPY --from=build /app/target/*.jar app.jar

# 開発環境用：ホットリロード対応
FROM maven:latest AS development

WORKDIR /app

# pom.xmlをコピー
COPY pom.xml .
RUN mvn dependency:go-offline -B

# ソースコードをマウントポイントとして使用
VOLUME ["/app/src", "/app/target"]

# Spring Boot DevToolsを使用してホットリロードを有効化
CMD ["mvn", "spring-boot:run", "-Dspring-boot.run.jvmArguments=-Dspring.devtools.restart.enabled=true"]

# 本番環境用の最終ステージ
FROM runtime AS production

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

# デフォルトは開発環境
FROM development
