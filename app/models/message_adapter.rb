require 'json'

class MessageAdapter < ApplicationRecord
  has_one_attached :importfile

  validates :importfile, presence: true

  # RabbitMQ レシーバ
  # file_processor から処理状況について受信する
  def self.receive_message

    conn = Bunny.new
    conn.start

    channel = conn.create_channel
    exchange = channel.topic("messageExchange")

    channel.queue('', :exclusive => true)
        .bind(exchange, :routing_key => "kassis.file.replay_messages.#").subscribe do |delivery_info, metadata, payload|

      logger.debug "ReplyMessage: #{payload}, routing key is #{delivery_info.routing_key}"

      x = JSON.parse(payload)
      ActionCable.server.broadcast('progresses:1', msg: x['msg'])
    end
  end
end

