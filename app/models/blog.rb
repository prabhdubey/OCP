class Blog < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_attached_file :image

  default_scope -> { order('created_at DESC') }


  after_create_commit { BlogBroadcastJob.perform_later self }
  scope :search, ->(title) { where("title like ?", "%#{title}%") }
  #attr_accessor :image
  # acts_as_commentable
  
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

end
