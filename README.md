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

```
rbenv install 2.5.1
brew install elasticsearch
brew install rabitmq
brew install redis
brew install kotlin

docker pull osixia/openldap
docker pull postgres:9.6.10
```

https://github.com/osixia/docker-openldap

docker run --name kassis-openldap-container --detach osixia/openldap
docker start -a kassis-openldap-container
docker run --name kassis-openldap-container --env LDAP_ORGANISATION="kassis" --env LDAP_DOMAIN="example.com" \
--env LDAP_ADMIN_PASSWORD="kassispassword" --detach osixia/openldap

docker exec kassis-openldap-container ldapsearch -x -H ldap://localhost -b dc=example,dc=com -D "cn=admin,dc=example,dc=com" -w kassispassword

## 開発メモ

### OpenLDAP (docker) セットアップ方法
https://github.com/osixia/docker-openldap

### RabbitMQ 管理者画面
http://localhost:15672/

## 製作者・貢献者 (Authors and contributors)
- [Akifumi NAKAMURA](https://github.com/nakamura-akifumi) ([@tmpz84](https://twitter.com/tmpz84))

## License
MIT
