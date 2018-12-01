# kassis_soda

資料管理システム

## 必要なソフトウェア

- Linux か Mac OS X
- Ruby 2.5
- Elasticsearch 6.4
- RabbitMQ 3.7
- PostgreSQL 9
- Redis
- OpenLDAP 2.4.46
- kassis_fileprocessor

## その他ライブラリ

- Cheetah Grid 
https://github.com/future-architect/cheetah-grid
- vanilla-autokana
https://github.com/ryo-utsunomiya/vanilla-autokana

## 開発環境構築(Mac OS X)

事前にrbenv、docker、homebrewの導入を済ませてください。
docker-composeで　OpenLDAP、RabbitMQ、phpldapadmin がインストールされます。

```
rbenv install 2.5.1
brew install elasticsearch
brew install redis
brew install kotlin
brew install node
brew install postgresql@9.6
```

```
git pull https://github.com/nakamura-akifumi/kassis_soda.git
rake db:migrate
rake db:seed
cd kassis_soda/ext/docker
docker-compose up -d
```

## 開発メモ

### OpenLDAP (docker) セットアップ方法
https://github.com/osixia/docker-openldap

### OpenLDAP (phpldapadmin) 管理画面
http://localhost:3100

cn=admin,dc=example,dc=com
kassispassword
でログイン可能。

### RabbitMQ 管理者画面
http://localhost:15672/

## 製作者・貢献者 (Authors and contributors)
- [Akifumi NAKAMURA](https://github.com/nakamura-akifumi) ([@tmpz84](https://twitter.com/tmpz84))

## License
MIT
