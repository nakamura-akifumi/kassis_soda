class ProgressChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def follow(data)
    stream_from("progresses:#{data['progress_id'].to_i}")
  end
end
