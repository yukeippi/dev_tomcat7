#!/bin/bash

# Tomcatのインストールディレクトリを指定
export CATALINA_HOME=/opt/tomcat

# プロジェクトディレクトリをCATALINA_BASEとして指定
export CATALINA_BASE=/workspace

# Tomcatを停止
$CATALINA_HOME/bin/catalina.sh stop
