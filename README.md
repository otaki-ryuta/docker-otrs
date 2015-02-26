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
$ cd <REPO_ROOT>
$ vgrant up
```

### 本番環境

```
$ eb init
$ eb create
```

```
$ eb deploy
```

