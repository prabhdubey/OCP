App.newcomment = App.cable.subscriptions.create "NewcommentChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log "newcomment connected"


  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log "newcomment disconnected"


  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
     $("#new_comment").append(data)

