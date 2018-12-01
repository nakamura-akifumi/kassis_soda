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
    exchange = channel.topic("messageExchange", :auto_delete => true)

    channel.queue('', :exclusive => true)
        .bind(exchange, :routing_key => "kassis.file.replay_messages.#").subscribe do |delivery_info, metadata, payload|

      logger.debug "ReplyMessage: #{payload}, routing key is #{delivery_info.routing_key}"

      ActionCable.server.broadcast('progresses:1', msg: "#{payload.msg}")
    end
  end

  def self.send_message(routing_key_suffix)
    conn = Bunny.new
    conn.start


    msgObj = {
      msgid: '',
      state: '',
      msg: 'かんりょう！',
      percent: 0.0,
      count: 0,
      recordSize: 0
    }

    routing_key = "kassis.file.replay_messages.#{routing_key_suffix}"

    channel = conn.create_channel
    exchange = channel.topic("messageExchange", :auto_delete => true)
    exchange.publish(msgObj.to_json, routing_key: routing_key)

  end

end

