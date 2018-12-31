
# TODO: 設定ファイルから読み込む
# TODO: docker-composeのcontainer名でホストを指定したい。
Elasticsearch::Model.client = Elasticsearch::Client.new({log: true,
                                                         hosts: { host: 'localhost'}})
