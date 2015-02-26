OTRS4向けDockerfileとデプロイ用設定ファイル
==========================================

- 開発環境 : [Vagrant](https://www.vagrantup.com/) バージョン1.5以上
  - VirtualBox
  - Mac OS X Yosemite(Windowsでも多分できます)
- 本番環境 : [AWS Elastic Beanstalk](http://aws.amazon.com/elasticbeanstalk/) Docker
  - [EB](http://docs.aws.amazon.com/ja_jp/elasticbeanstalk/latest/dg/command-reference-eb.html) バージョン3

## デプロイ手順

### 開発環境

VirtualBoxの仮想マシン上にOTRSとMySQLのDockerコンテナを構成します(**MySQLのコンテナは未実装**)。
諸々Vagrantで自動化してあるので、Vagrantの操作で一括デプロイできます。具体的な設定は、`Vagrantfile`を参照ください。

1. VagrantでVMイメージ(Box)をダウンロードします。数分〜数十分かかります。
```
$ vagrant box add utopic64 https://cloud-images.ubuntu.com/vagrant/utopic/current/utopic-server-cloudimg-amd64-vagrant-disk1.box
```
2. `Vagrantfile`を読み込んでVM作成し、AnsibleでDockerをインストール、VagrantのDocker ProvisionerでDockerfileからの`docker build`、コンテナを実行する`docker run`が走ります。
```
$ cd <REPO_ROOT>
$ vagrant up
```
3.  VMは固定IP`192.168.33.11`が振られるので、ブラウザで`http://192.168.33.11/otrs/installer.pl`にアクセスすればOTRSのインストールウィザードが表示されます。

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

- (未)開発環境のMySQLコンテナの構成を追加

## メンテナ

- Ryuta Otaki (@takipone)
