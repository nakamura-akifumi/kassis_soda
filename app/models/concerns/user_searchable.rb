module UserSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    # インデックスするフィールドの一覧
    INDEX_FIELDS = %w(username email personid cardid full_name full_name_transcription expired_at registration_date deactive_at updated_at created_at).freeze
    # インデックス名
    index_name "user_#{Rails.env}_index"
    # マッピング情報
    settings index: {
        number_of_shards: 1,
        number_of_replicas: 0,
        analysis: {
          filter: {
            greek_lowercase_filter: {
              type:     'lowercase',
              language: 'greek',
            },
          },
          tokenizer: {
            "ja-ma-tokenizer": {
              "type": 'kuromoji_tokenizer',
              "mode": 'normal'
            },
            "ja-2gram-tokenizer": {
              "type": 'nGram',
              "min_gram": '2',
              "max_gram": '2'
            }
          },
          analyzer: {
            "ja-ma-analyzer": {
              "type": 'custom',
              "tokenizer": 'ja-ma-tokenizer',
              "filter": %w(kuromoji_baseform greek_lowercase_filter cjk_width)
            },
            "ja-2gram-analyzer": {
              "type": 'custom',
              "tokenizer": 'ja-2gram-tokenizer'
            }
          }
        }
    } do
      mappings dynamic: 'false' do

        indexes :username, type: 'keyword'
        indexes :email, type: 'keyword'
        indexes :personid, type: 'keyword'
        indexes :cardid, type: 'keyword'
        indexes :full_name, analyzer: 'ja-ma-analyzer', type: 'text'
        indexes :full_name_ngram, analyzer: 'ja-2gram-analyzer', type: 'text'
        indexes :full_name_transcription, analyzer: 'ja-ma-analyzer', type: 'text'
        indexes :full_name_transcription_ngram, analyzer: 'ja-2gram-analyzer', type: 'text'
        indexes :expired_at, type: 'date', format: 'date_time'
        indexes :registration_date, type: 'date', format: 'date'
        indexes :updated_at, type: 'date', format: 'date_time'
        indexes :created_at, type: 'date', format: 'date_time'
        indexes :deactive_at, type: 'date', format: 'date_time'
        indexes :user_id, type: 'integer', index: false, store: true

      end
    end

    def as_indexed_json(option = {})
      hash = self.as_json.select { |k, _| INDEX_FIELDS.include?(k) }
      hash[:full_name_ngram] = self.full_name
      hash[:full_name_transcription_ngram] = self.full_name_transcription
      hash[:user_id] = self.id

      hash
    end
  end

  module ClassMethods
    # indexの作成メソッド
    def create_index!
      client = __elasticsearch__.client
      client.indices.delete index: self.index_name rescue nil
      client.indices.create(index: self.index_name,
                            body: {
                                settings: self.settings.to_hash,
                                mappings: self.mappings.to_hash
                            })
    end

  end

end