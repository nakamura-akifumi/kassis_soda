App.progress = App.cable.subscriptions.create "ProgressChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    @install()
    @follow()

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#file_status').text("#{data.msg}")

  follow: ->
    # 例示のため、購読対象の識別子 (progress_id) は決め打ち
    @perform('follow', progress_id: 1)

  install: ->
    $(document).on('page:change', -> App.progresses.follow())