class User < ApplicationRecord
 has_many :authentications
 has_many :blogs
  has_many :comments
  has_many :messages



 has_attached_file :avatar
 validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]



  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :omniauthable, :omniauth_providers => [:facebook, :google]
 
 validates :password, :presence => true, :length => {:within => 6..40}

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
	  # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	  #   user.email = auth.info.email
	  #   user.password = Devise.friendly_token[0,20]
	  #   user.name = auth.info.name   # assuming the user model has a name
	  #   user.image = auth.info.image # assuming the user model has an image
	  # end
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
