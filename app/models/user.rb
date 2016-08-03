class User < ApplicationRecord
   has_many :authentications
   has_many :blogs
   has_many :comments
   has_many :messages

   has_attached_file :avatar
   validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

   devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :omniauthable, :omniauth_providers => [:facebook, :google]
   
   validates :password, :presence => true, :length => {:within => 6..40}
   validates :first_name, :presence => true
   validates :email, :presence => true

   def self.create_user_with_omniauth(user, auth)
      if user
        user.first_name = auth.info.name
      else
        user = User.new(first_name: auth.info.name, email: auth.info.email)
        user.password = Devise.friendly_token[0,20]  
      end
      avatar_url= process_uri(auth.info.image)
      user.update_attribute(:avatar, URI.parse(avatar_url))
      user.authentications.build(provider: auth.provider, uid: auth.uid)
      user.skip_confirmation!
      user.save
      user
  end

  def self.from_omniauth(auth) 
    p auth
    authentication = Authentication.find_by(provider: auth.provider, uid: auth.uid)
    if authentication
      user = authentication.user
      unless user
          tuser = User.find_by(email: auth.info.email)
          if tuser.present?
             user = tuser 
             avatar_url= process_uri(auth.info.image)
             user.update_attribute(:avatar, URI.parse(avatar_url))
          else
             user = User.new(first_name: auth.info.name, email: auth.info.email)
             user.password = Devise.friendly_token[0,20]  
             user.skip_confirmation!
             user.save
          end
          authentication.update(user_id: user.id)
      end
    else
      tuser = User.find_by(email: auth.info.email)
      if tuser.present?
        user = tuser   
        avatar_url= process_uri(auth.info.image)
        user.update_attribute(:avatar, URI.parse(avatar_url))
      else
        user = nil
      end
        user = User.create_user_with_omniauth(user, auth)
    end
     avatar_url= process_uri(auth.info.image)
     user.update_attribute(:avatar, URI.parse(avatar_url))
     
    user
  end

  private
    def self.process_uri(uri)
      require 'open-uri'
      require 'open_uri_redirections'
      open(uri, :allow_redirections => :safe) do |r|
            r.base_uri.to_s
      end
  end
end
