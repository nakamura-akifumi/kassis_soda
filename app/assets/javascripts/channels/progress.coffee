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
    @perform('follow', progress_id: 1)

  install: ->
    $(document).on('page:change', -> App.progresses.follow())