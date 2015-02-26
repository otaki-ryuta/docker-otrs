OTRS4向けDockerfileとデプロイ用設定ファイル
==========================================

- 開発環境 : [Vagrant](https://www.vagrantup.com/) バージョン1.5以上
  - VirtualBox
  - Mac OS X Yosemite(Windowsでも多分できます)
- 本番環境 : [AWS Elastic Beanstalk](http://aws.amazon.com/elasticbeanstalk/) Docker
  - [EB](http://docs.aws.amazon.com/ja_jp/elasticbeanstalk/latest/dg/command-reference-eb.html) バージョン3

## デプロイ手順

### 開発環境

```
$ vagrant box add utopic64 https://cloud-images.ubuntu.com/vagrant/utopic/current/utopic-server-cloudimg-amd64-vagrant-disk1.box
```

```
$ cd <REPO_ROOT>
$ vagrant up
```

ブラウザで`192.168.33.11/otrs/installer.pl`にアクセス

### 本番環境

```
$ cd <REPO_ROOT>
$ eb init
$ eb create
```

```
$ eb deploy
```

