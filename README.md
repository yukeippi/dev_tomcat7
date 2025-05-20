# Java7 + Tomcat7 サンプルアプリケーション

このリポジトリは、Java7とTomcat7を使用した簡単なWebアプリケーションのサンプルです。「Hello World」を表示するシンプルなサーブレットアプリケーションが含まれています。

## 前提条件

- Java 7 JDK
- Tomcat 7（/opt/tomcatにインストール済みであること）
- PostgreSQL 14（開発環境に含まれています）

## ディレクトリ構造

```
/workspace/
├── build.sh           # ビルドスクリプト
├── startup.sh         # 起動スクリプト
├── shutdown.sh        # 停止スクリプト
├── conf/              # Tomcat設定ファイル
│   ├── server.xml     # メインサーバー設定
│   ├── web.xml        # デフォルトWebアプリケーション設定
│   ├── context.xml    # デフォルトコンテキスト設定
│   └── Catalina/
│       └── localhost/
│           └── hello.xml  # helloアプリケーション固有の設定
├── lib/               # 共通ライブラリ
│   ├── servlet-api.jar
│   ├── jsp-api.jar
│   └── el-api.jar
├── logs/              # ログファイル
├── temp/              # 一時ファイル
├── src/               # ソースコード
│   └── hello/
│       └── HelloServlet.java  # サンプルサーブレット
├── webapps/           # Webアプリケーション
│   └── hello/         # helloアプリケーション
│       ├── index.html # トップページ
│       ├── META-INF/
│       │   └── context.xml
│       └── WEB-INF/
│           ├── web.xml  # アプリケーション設定
│           └── classes/ # コンパイル済みクラスファイル
└── work/              # Tomcat作業ディレクトリ
```

## ビルド方法

アプリケーションをビルドするには、以下のコマンドを実行します：

```bash
./build.sh
```

このスクリプトは、`src/hello/HelloServlet.java`をコンパイルし、コンパイル済みクラスファイルを`webapps/hello/WEB-INF/classes/hello/`ディレクトリに配置します。

## 起動と停止

### Tomcatの起動

```bash
./startup.sh
```

このスクリプトは、以下の環境変数を設定します：
- `CATALINA_HOME=/opt/tomcat`（Tomcatのインストールディレクトリ）
- `CATALINA_BASE=/workspace`（プロジェクトディレクトリ）

また、必要なディレクトリ構造（logs、temp、work）を作成し、Tomcatを起動します。

### Tomcatの停止

```bash
./shutdown.sh
```

## アプリケーションへのアクセス

Tomcatが起動したら、以下のURLでアプリケーションにアクセスできます：

- トップページ: http://localhost:8080/hello/
- サーブレット: http://localhost:8080/hello/hello

## アプリケーションの説明

このサンプルアプリケーションは、以下のコンポーネントで構成されています：

1. **トップページ（index.html）**
   - シンプルなHTMLページ
   - 「Hello Worldサーブレットを表示」ボタンがあり、クリックするとサーブレットにアクセスします

2. **HelloServlet**
   - `/hello`パスにマッピングされたシンプルなサーブレット
   - 「Hello World!」メッセージとアプリケーションの説明を表示します

## 新しいサーブレットの追加方法

1. `src/hello/`ディレクトリに新しいサーブレットクラスを作成します
2. `@WebServlet`アノテーションを使用してURLパスを指定します
3. `build.sh`を実行してコンパイルします
4. Tomcatを再起動します（`./shutdown.sh`と`./startup.sh`を実行）

例：

```java
package hello;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/newservlet")
public class NewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>新しいサーブレット</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>新しいサーブレットです！</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}
```

## PostgreSQLの設定と使用方法

このプロジェクトには、PostgreSQL 14データベースが含まれています。開発環境では、以下の設定でPostgreSQLが自動的に起動します：

- ホスト: postgres（コンテナ内からのアクセス）または localhost（ホストマシンからのアクセス）
- ポート: 5432
- ユーザー名: postgres
- パスワード: postgres
- データベース名: tomcatdb

### PostgreSQLへの接続

#### コマンドラインからの接続

Tomcatコンテナ内からPostgreSQLに接続するには、以下のコマンドを使用します：

```bash
psql -h db -U postgres -d tomcatdb
```

パスワードを求められたら、`postgres`と入力します。

#### JDBCを使用したJavaからの接続

JavaアプリケーションからPostgreSQLに接続するには、以下のJDBCコードを使用します：

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class PostgreSQLConnection {
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        String url = "jdbc:postgresql://postgres:5432/tomcatdb";
        String user = "postgres";
        String password = "postgres";
        return DriverManager.getConnection(url, user, password);
    }
}
```

### サンプルデータベース操作

以下は、PostgreSQLでテーブルを作成し、データを挿入して取得する簡単なサーブレットの例です：

```java
package hello;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/dbtest")
public class DatabaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    public void init() throws ServletException {
        try {
            // テーブルの作成
            try (Connection conn = PostgreSQLConnection.getConnection();
                 Statement stmt = conn.createStatement()) {
                
                String sql = "CREATE TABLE IF NOT EXISTS users (" +
                             "id SERIAL PRIMARY KEY, " +
                             "name VARCHAR(100) NOT NULL, " +
                             "email VARCHAR(100) NOT NULL)";
                stmt.executeUpdate(sql);
                
                // サンプルデータの挿入
                sql = "INSERT INTO users (name, email) VALUES " +
                      "('ユーザー1', 'user1@example.com'), " +
                      "('ユーザー2', 'user2@example.com') " +
                      "ON CONFLICT DO NOTHING";
                stmt.executeUpdate(sql);
            }
        } catch (Exception e) {
            throw new ServletException("データベースの初期化に失敗しました", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>データベーステスト</title>");
            out.println("<meta charset=\"UTF-8\">");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>PostgreSQLデータベーステスト</h1>");
            
            try (Connection conn = PostgreSQLConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT id, name, email FROM users")) {
                
                out.println("<table border='1'>");
                out.println("<tr><th>ID</th><th>名前</th><th>メール</th></tr>");
                
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id") + "</td>");
                    out.println("<td>" + rs.getString("name") + "</td>");
                    out.println("<td>" + rs.getString("email") + "</td>");
                    out.println("</tr>");
                }
                
                out.println("</table>");
            } catch (Exception e) {
                out.println("<p>エラー: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
            
            out.println("</body>");
            out.println("</html>");
        }
    }
}
```

このサーブレットを使用するには、`PostgreSQLConnection.java`クラスも作成し、両方のファイルをコンパイルしてデプロイする必要があります。

## トラブルシューティング

### ログファイル

問題が発生した場合は、以下のログファイルを確認してください：

- Tomcatのログ: `logs/catalina.out`
- アクセスログ: `logs/localhost_access_log.*.txt`

### 一般的な問題

1. **ポート8080が既に使用されている**
   - `conf/server.xml`ファイルを編集して、別のポートを指定します

2. **コンパイルエラー**
   - Javaのバージョンが正しいことを確認します（Java 7が必要）
   - コンパイルエラーメッセージを確認し、コードを修正します

3. **404エラー（ページが見つかりません）**
   - URLが正しいことを確認します
   - `conf/Catalina/localhost/hello.xml`の設定を確認します
   - アプリケーションが正しくデプロイされていることを確認します

4. **500エラー（サーバーエラー）**
   - `logs/catalina.out`でエラーメッセージを確認します
   - サーブレットコードにバグがないか確認します

5. **PostgreSQLへの接続エラー**
   - PostgreSQLサービスが実行中であることを確認します
   - 接続情報（ホスト、ポート、ユーザー名、パスワード）が正しいことを確認します
   - JDBCドライバが正しくロードされていることを確認します
   - ネットワーク接続に問題がないことを確認します

6. **データベース操作エラー**
   - SQLクエリの構文が正しいことを確認します
   - テーブルとカラムが存在することを確認します
   - 適切な権限があることを確認します
