class Comment < ApplicationRecord
  after_create_commit { CommentBroadcastJob.perform_later self }
  after_create_commit { ReCommentBroadcastJob.perform_later self }
  # include ActsAsCommentable::Comment

  # belongs_to :commentable, :polymorphic => true

  default_scope -> { order('created_at ASC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  validates  :body, :presence => true


  # NOTE: Comments belong to a user
  belongs_to :user
  belongs_to :blog
end
