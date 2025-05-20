#!/bin/bash

# Tomcatのインストールディレクトリを指定
export CATALINA_HOME=/opt/tomcat

# プロジェクトディレクトリをCATALINA_BASEとして指定
export CATALINA_BASE=/workspace

# 必要なディレクトリ構造を確認
mkdir -p $CATALINA_BASE/logs
mkdir -p $CATALINA_BASE/temp
mkdir -p $CATALINA_BASE/work

# Tomcatを起動
$CATALINA_HOME/bin/catalina.sh run
