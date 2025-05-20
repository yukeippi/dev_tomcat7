#!/bin/bash
# HelloServletのコンパイル
mkdir -p webapps/hello/WEB-INF/classes/hello
CLASSPATH="lib/servlet-api.jar:lib/jsp-api.jar:lib/el-api.jar"
javac -d webapps/hello/WEB-INF/classes -cp "$CLASSPATH" src/hello/HelloServlet.java
echo "ビルド完了"
