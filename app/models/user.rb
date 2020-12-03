class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :contributions, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  def self.from_google(email:, full_name:, uid:, avatar_url:)
    create_with(uid: uid, name: full_name, apiKey: "abc").find_or_create_by!(email: email[0..email.index('@')-1])
  end
  
end
