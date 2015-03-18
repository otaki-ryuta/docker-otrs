OTRS4向けDockerfileとデプロイ用設定ファイル
==========================================

- 開発環境 : [Docker Compose](https://docs.docker.com/compose/) バージョン1.1
  - VirtualBox
  - Boot2Docker
  - Mac OS X Yosemite(Windowsでも多分できます)
- 本番環境 : [AWS Elastic Beanstalk](http://aws.amazon.com/elasticbeanstalk/) Docker
  - [EB](http://docs.aws.amazon.com/ja_jp/elasticbeanstalk/latest/dg/command-reference-eb.html) バージョン3

## デプロイ手順

### 開発環境

VirtualBoxのBoot2Docker仮想マシン上にOTRSとMySQLのDockerコンテナを構成します
諸々Docker Composeで自動化してあるので、`docker-compose`コマンドの操作で一括デプロイできます。具体的な設定は、`docker-compose.yml`を参照ください。

1. Boot2Dockerをセットアップし、仮想マシンを起動します。
```
$ boot2docker init
$ boot2docker up
(コマンド実行結果の末尾3行を~/.bash_profileに追記して再ログイン)
    export DOCKER_CERT_PATH=/Users/ryuta/.boot2docker/certs/boot2docker-vm
    export DOCKER_TLS_VERIFY=1
    export DOCKER_HOST=tcp://192.168.59.103:2376
$ docker version
```
2. Docker Composeを実行
```
$ cd <REPO_ROOT>
$ docker-compose build
$ docker-compose up
```
3.  VMのIPアドレスは、`boot2docker ip`で確認できるので、ブラウザで`http://IPアドレス/installer.pl`にアクセスすればOTRSのインストールウィザードが表示されます。

### 本番環境

Elastic Beanstalkを操作するCLIツール、EBをここでは利用します。

1. 以下のコマンドでBeanstalkのEnvironmentおよびEC2インスタンスが作成されます。
```
$ cd <REPO_ROOT>
$ eb init
$ eb create
```
2. `eb deploy`で`Dockerfile`と`Dockerrun.aws.json`がアップロードされ、新しいバージョンとしてデプロイされます。
```
$ eb deploy
```
3. 開発環境と同じく、WebブラウザでElastic BeanstalkのURL`*.elasticbeanstalk.com/otrs/installer.pl`にアクセスすれば、OTRSのインストールウィザードが表示されます。

## OTRSの構成

`Dockerfile`の`ADD`により、Apacheの設定は`httpd/zzz_otrs.conf`が`/etc/httpd/conf.d`に、OTRSの設定は`otrs/Config.pm`が`/opt/otrs/Kernel/`にコピーされます。これら以外のファイルをコンテナにコピーしたい場合は、ファイルをリポジトリ内に配置のうえ、`Dockerfile`に`ADD`行を追加してください。

## TODO

-

## メンテナ

- Ryuta Otaki (@takipone)
