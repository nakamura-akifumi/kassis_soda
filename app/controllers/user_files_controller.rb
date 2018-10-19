class UserFilesController < ApplicationController
  def new
    @file_adapter = FileAdapter.new
  end

  def create
    @file_adapter = FileAdapter.new(file_adapter_params)

    rabbitmq_hostname = Rails.application.config.rabbitmq.host
    rabbitmq_quename = Rails.application.config.rabbitmq.quename
    connection = Bunny.new(hostname: rabbitmq_hostname)
    connection.start

    if @file_adapter.save

      attachment = @file_adapter.importfile
      dest_dir = File.join(
          "storage",
          attachment.blob.key.first(2),
          attachment.blob.key.first(4).last(2))

      message = ({filepath: dest_dir, blob: @file_adapter.importfile.blob.to_json}).to_json

      channel = connection.create_channel
      queue = channel.queue(rabbitmq_quename)
      queue.publish(message, persistent: true)
      connection.close
      logger.info " [x] Sent #{message}"
      redirect_to user_files_show_path(@file_adapter.id), notice: 'File adapter was successfully created.'
    else
      render :new
    end
  end

  def index
  end

  def show
  end

  private
  def file_adapter_params
    logger.debug("@@")
    params.permit(:name, :importfile)
  end
end
