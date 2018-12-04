class UserFilesController < ApplicationController
  def new
    @message_adapter = MessageAdapter.new
  end

  def create
    @message_adapter = MessageAdapter.new(message_adapter_params)

    rabbitmq_hostname = Rails.application.config.rabbitmq.host
    rabbitmq_quename = Rails.application.config.rabbitmq.quename
    connection = Bunny.new(hostname: rabbitmq_hostname)
    connection.start

    @message_adapter.msgid = SecureRandom.uuid
    @message_adapter.created_by = current_user.id
    @message_adapter.status = 'set' # set -> (accepted) -> processing -> processed
    @message_adapter.state = 'normal' # normal -> error or sucess

    if @message_adapter.save

      attachment = @message_adapter.importfile
      dest_dir = File.join(
            Rails.root,
          "storage",
            attachment.blob.key.first(2),
            attachment.blob.key.first(4).last(2))
      filepath = File.join(dest_dir, @message_adapter.importfile.blob.key)

      message = ({msgid: @message_adapter.msgid, filepath: filepath, blob: @message_adapter.importfile.blob}).to_json

      channel = connection.create_channel
      queue = channel.queue(rabbitmq_quename)
      queue.publish(message, persistent: true)
      connection.close
      logger.info " [x] Sent Message q:#{rabbitmq_quename} m:#{message}"
      redirect_to user_files_show_path(@message_adapter.id), notice: 'Message adapter was successfully created.'
    else
      render :new
    end
  end

  def index
  end

  def show
    @message_adapter = MessageAdapter.find(params['id'])
    @message_histories = MessageHistory.where(msgid: @message_adapter.msgid)
  end

  private
  def message_adapter_params
    params.permit(:name, :importfile)
  end
end
