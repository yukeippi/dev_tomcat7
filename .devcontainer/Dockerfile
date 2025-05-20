FROM debian:bullseye

# デフォルトシェルをbashに設定
SHELL ["/bin/bash", "-c"]

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    unzip \
    bash \
    zsh \
    vim \
    net-tools \
    htop \
    readline-common \
    libreadline-dev \
    postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# OpenJDK 7のインストール
RUN mkdir -p /opt/java && \
    curl -L https://download.java.net/openjdk/jdk7u75/ri/jdk_ri-7u75-b13-linux-x64-18_dec_2014.tar.gz | \
    tar -xz -C /opt/java && \
    ln -s /opt/java/java-se-7u75-ri /opt/java/jdk7

# 環境変数の設定
ENV JAVA_HOME=/opt/java/jdk7
ENV PATH=$JAVA_HOME/bin:$PATH

# Tomcat 7のインストール
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

WORKDIR /tmp
RUN wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz \
    && mkdir -p /opt/tomcat \
    && tar -xf apache-tomcat-7.0.109.tar.gz -C /opt/tomcat --strip-components=1 \
    && rm apache-tomcat-7.0.109.tar.gz

# Tomcatの権限設定
RUN chmod +x /opt/tomcat/bin/*.sh

# PostgreSQL JDBCドライバのインストール
WORKDIR /tmp
RUN wget https://jdbc.postgresql.org/download/postgresql-42.5.0.jar \
    && mv postgresql-42.5.0.jar /opt/tomcat/lib/

# vscodeユーザーの作成
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# ユーザーとグループの作成
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # sudo権限の付与
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # 必要なディレクトリの所有権をvscodeユーザーに変更
    && chown -R $USERNAME:$USERNAME /opt/tomcat \
    && mkdir -p /home/$USERNAME/.vscode-server \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/.vscode-server \
    && mkdir -p /workspace \
    && chown -R $USERNAME:$USERNAME /workspace

# 作業ディレクトリの設定
WORKDIR /app

# アプリケーションのソースコードをコピー
COPY . /app/

# WARファイルをTomcatのwebappsディレクトリにコピー（必要に応じて手動でコピー）
# RUN cp /app/target/hello-world.war /opt/tomcat/webapps/

# ポートの公開
EXPOSE 8080

# コンテナが終了しないようにする
CMD ["sleep", "infinity"]
