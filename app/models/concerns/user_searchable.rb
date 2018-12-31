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
        number_of_shards:   1,
        number_of_replicas: 0,
        analysis: {
            filter: {
                pos_filter: {
                    type:     'kuromoji_part_of_speech',
                    stoptags: ['助詞-格助詞-一般', '助詞-終助詞'],
                },
                greek_lowercase_filter: {
                    type:     'lowercase',
                    language: 'greek',
                },
            },
            tokenizer: {
                kuromoji: {
                    type: 'kuromoji_tokenizer'
                },
                ngram_tokenizer: {
                    type: 'nGram',
                    min_gram: '2',
                    max_gram: '3',
                    token_chars: ['letter', 'digit']
                }
            },
            analyzer: {
                kuromoji_analyzer: {
                    type:      'custom',
                    tokenizer: 'kuromoji_tokenizer',
                    filter:    ['kuromoji_baseform', 'pos_filter', 'greek_lowercase_filter', 'cjk_width'],
                },
                ngram_analyzer: {
                    tokenizer: "ngram_tokenizer"
                }
            }
        }
    } do
      mappings dynamic: 'false' do # 動的にマッピングを生成しない

        indexes :username, analyzer: 'kuromoji', type: 'text'
        indexes :email, analyzer: 'kuromoji', type: 'text'
        indexes :personid, analyzer: 'kuromoji', type: 'text'
        indexes :cardid, analyzer: 'kuromoji', type: 'text'
        indexes :full_name, analyzer: 'kuromoji_analyzer', type: 'text'
        indexes :full_name_transcription, analyzer: 'kuromoji_analyzer', type: 'text'
        indexes :expired_at, type: 'date', format: 'date_time'
        indexes :registration_date, type: 'date', format: 'date'
        indexes :updated_at, type: 'date', format: 'date_time'
        indexes :created_at, type: 'date', format: 'date_time'
        indexes :deactive_at, type: 'date', format: 'date_time'

      end
    end
    # インデックスするデータを生成
    # @return [Hash]
    def as_indexed_json(option = {})
      self.as_json.select { |k, _| INDEX_FIELDS.include?(k) }
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