class CommentBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
  	p comment
      ActionCable.server.broadcast 'reccomment_channel', render_message(comment)
  end
 
  private
    def render_message(comment)
      ApplicationController.renderer.render(partial: 'comments/recent_comment', locals: { comment: comment })
    end
end
