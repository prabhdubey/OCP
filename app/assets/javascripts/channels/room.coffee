App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log "room connected"
    
  disconnected: ->
    # Called when the subscription has been terminated by the server
 
  received: (data) ->
    $('#messages').append data['message']
    $(".panel-body").scrollTop(9999999999999)
    # Called when there's incoming data on the websocket for this channel
 
  speak: (message) ->
    @perform 'speak', message
 
$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
  if event.keyCode is 13 # return = send
    message = 
      user_id: $("#user_id").val()
      content: event.target.value
    App.room.speak message
    event.target.value = ""
    event.preventDefault()
