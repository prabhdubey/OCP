App.blog = App.cable.subscriptions.create "BlogChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log "newblogs connected"

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log "newblogs disconnected"

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log data
    $("#newblogs").append(data)