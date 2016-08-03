class BlogBroadcastJob < ApplicationJob
 queue_as :default

  def perform(blog)
    ActionCable.server.broadcast('blog_channel', render_message(blog)) if blog.flag == 1
  end
 
  private
    def render_message(blog)
      ApplicationController.renderer.render(partial: 'blogs/newblogs', locals: { blog: blog })
    end
end
